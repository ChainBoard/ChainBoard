$(document).ready(function () {
    if (document.querySelector("#comment-canvas") === null) {
        return;
    }

    var Query = function(query, callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("get", "/api/comments?" + query);
        xhr.responseType = "json";
        xhr.addEventListener("load", function() {
            callback(xhr.response);
        });
        xhr.send();
    };

    var QueryUI = function(query, callback) {
        var withDefaultStyle = function(obj) {
            return Object.assign({
                color: "#324615" //Node Color
            }, obj);
        };

        Query(query, function(response) {
            var commentNodes = {};

            for (var i = 0; i < response.comments.length; i++) {
                commentNodes[response.comments[i].id] = withDefaultStyle(response.comments[i]);

                if (response.comments[i].parent !== null) {
                    commentNodes[response.comments[i].parent.id] = withDefaultStyle(response.comments[i].parent);
                }

                for (var j = 0; j < response.comments[i].children.length; j++) {
                    commentNodes[response.comments[i].children[j].id] = withDefaultStyle(response.comments[i].children[j]);
                }
            }

            var commentEdges = {};
            for (var i = 0; i < response.comments.length; i++) {
                if (response.comments[i].parent !== null) {
                    if (commentEdges[response.comments[i].parent.id] === undefined) {
                        commentEdges[response.comments[i].parent.id] = {};
                    }
                    commentEdges[response.comments[i].parent.id][response.comments[i].id] = {};
                }
                if (response.comments[i].children.length > 0) {
                    if (commentEdges[response.comments[i].id] === undefined) {
                        commentEdges[response.comments[i].id] = {};
                    }
                    for (var j = 0; j < response.comments[i].children.length; j++) {
                        commentEdges[response.comments[i].id][response.comments[i].children[j].id] = {};
                    }
                }
            }

            callback({
                nodes: commentNodes,
                edges: commentEdges
            });
        });
    };

    var Renderer = function (elt) {
        var dom = $(elt);
        var canvas = dom.get(0);
        var gfx = arbor.Graphics(canvas);
        var sys = null;

        var _vignette = null;
        var selected = null,
            nearest = null,
            _mouseP = null;

        var that = {
            init: function (pSystem) {
                sys = pSystem;
                sys.screen({
                    size: {
                        width: dom.width(),
                        height: dom.height()
                    },
                    padding: [36, 60, 36, 60]
                });

                $(window).resize(that.resize);
                that.resize();
                that._initMouseHandling();
            },
            resize: function () {
                canvas.width = $(window).width();
                canvas.height = .75 * $(window).height();
                sys.screen({
                    size: {
                        width: canvas.width,
                        height: canvas.height
                    }
                });
                _vignette = null;
                that.redraw();
            },
            redraw: function () {
                gfx.clear();
                sys.eachEdge(function (edge, p1, p2) {
                    gfx.line(p1, p2, {
                        stroke: "#808C6D",//Edge Color
                        width: 2
                    });
                });
                sys.eachNode(function (node, pt) {
                    var w = Math.max(20, 20 + gfx.textWidth(node.data.body));
                    gfx.rect(pt.x - w / 2, pt.y - 8, w, 20, 4, {
                        fill: node.data.color
                    });
                    gfx.text(node.data.body, pt.x, pt.y + 9, {
                        color: "white",
                        align: "center",
                        font: "Arial",
                        size: 12
                    });
                });
            },
            switchMode: function (e) {
                if (e.mode === 'hidden') {
                    dom.stop(true).fadeTo(e.dt, 0, function () {
                        if (sys) sys.stop();
                        $(this).hide();
                    });
                } else if (e.mode === 'visible') {
                    dom.stop(true).css('opacity', 0).show().fadeTo(e.dt, 1, function () {
                        that.resize();
                    });
                    if (sys) {
                        sys.start();
                    }
                }
            },
            switchSection: function (newSection) {
                var parent = sys.getEdgesFrom(newSection)[0].source;
                var children = $.map(sys.getEdgesFrom(newSection), function (edge) {
                    return edge.target;
                });

                sys.eachNode(function (node) {
                    var nowVisible = ($.inArray(node, children) >= 0);
                    var newAlpha = (nowVisible) ? 1 : 0;
                    var dt = (nowVisible) ? .5 : .5;
                    sys.tweenNode(node, dt, {
                        alpha: newAlpha
                    });

                    if (newAlpha === 1) {
                        node.p.x = parent.p.x + .05 * Math.random() - .025;
                        node.p.y = parent.p.y + .05 * Math.random() - .025;
                        node.tempMass = .001;
                    }
                })
            },
            _initMouseHandling: function () {
                // no-nonsense drag and drop (thanks springy.js)
                selected = null;
                nearest = null;
                var dragged = null;
                var oldmass = 1;

                var _section = null;

                var handler = {
                    moved: function (e) {
                        var pos = $(canvas).offset();
                        _mouseP = arbor.Point(e.pageX - pos.left, e.pageY - pos.top);
                        nearest = sys.nearest(_mouseP);

                        if (!nearest.node) {
                            return false;
                        }

                        selected = (nearest.distance < 50) ? nearest : null;

                        return false;
                    },
                    clicked: function (e) {
                        var pos = $(canvas).offset();
                        _mouseP = arbor.Point(e.pageX - pos.left, e.pageY - pos.top);
                        nearest = dragged = sys.nearest(_mouseP);

                        if (nearest && selected && nearest.node === selected.node) {
                            QueryUI("id=" + selected.node.data.id, function (ui) {
                                sys.graft(ui);
                            });
                            return false;
                        }

                        if (dragged && dragged.node !== null) {
                            dragged.node.fixed = true;
                        }

                        $(canvas).unbind('mousemove', handler.moved);
                        $(canvas).bind('mousemove', handler.dragged);
                        $(window).bind('mouseup', handler.dropped);

                        return false;
                    },
                    dragged: function (e) {
                        var old_nearest = nearest && nearest.node._id;
                        var pos = $(canvas).offset();
                        var s = arbor.Point(e.pageX - pos.left, e.pageY - pos.top);

                        if (!nearest) {
                            return;
                        }

                        if (dragged !== null && dragged.node !== null) {
                            dragged.node.p = sys.fromScreen(s);
                        }

                        return false
                    },
                    dropped: function (e) {
                        if (dragged === null || dragged.node === undefined) {
                            return;
                        }

                        if (dragged.node !== null) {
                            dragged.node.fixed = false;
                        }

                        dragged.node.tempMass = 1000;
                        dragged = null;
                        // selected = null
                        $(canvas).unbind('mousemove', handler.dragged);
                        $(window).unbind('mouseup', handler.dropped);
                        $(canvas).bind('mousemove', handler.moved);
                        _mouseP = null;
                        return false;
                    }
                };

                $(canvas).mousedown(handler.clicked);
                $(canvas).mousemove(handler.moved);
            }
        };

        return that;
    };

    var sys = arbor.ParticleSystem();
    sys.parameters({
        stiffness: 900,
        repulsion: 2000,
        gravity: true,
        dt: 0.015
    });
    sys.renderer = Renderer("#comment-canvas");

    QueryUI("", function (ui) {
        sys.graft(ui);
    });
});
