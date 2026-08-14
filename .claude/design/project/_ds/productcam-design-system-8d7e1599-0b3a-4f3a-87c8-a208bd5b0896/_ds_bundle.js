/* @ds-bundle: {"format":4,"namespace":"ProductCamDesignSystem_8d7e15","components":[{"name":"BatchThumb","sourcePath":"components/batch/BatchThumb.jsx"},{"name":"ProgressTrace","sourcePath":"components/batch/ProgressTrace.jsx"},{"name":"CONTOUR_SHAPES","sourcePath":"components/camera/ContourOverlay.jsx"},{"name":"ContourOverlay","sourcePath":"components/camera/ContourOverlay.jsx"},{"name":"ModeToggle","sourcePath":"components/camera/ModeToggle.jsx"},{"name":"Readout","sourcePath":"components/camera/Readout.jsx"},{"name":"ShutterButton","sourcePath":"components/camera/ShutterButton.jsx"},{"name":"Badge","sourcePath":"components/core/Badge.jsx"},{"name":"Button","sourcePath":"components/core/Button.jsx"},{"name":"Chip","sourcePath":"components/core/Chip.jsx"},{"name":"Icon","sourcePath":"components/core/Icon.jsx"},{"name":"IconButton","sourcePath":"components/core/IconButton.jsx"},{"name":"Sheet","sourcePath":"components/core/Sheet.jsx"},{"name":"PC_BACKGROUNDS","sourcePath":"components/editor/BackgroundSwatchPicker.jsx"},{"name":"BackgroundSwatchPicker","sourcePath":"components/editor/BackgroundSwatchPicker.jsx"},{"name":"CheckerSurface","sourcePath":"components/editor/CheckerSurface.jsx"},{"name":"Slider","sourcePath":"components/editor/Slider.jsx"},{"name":"EdgeNotice","sourcePath":"components/feedback/EdgeNotice.jsx"},{"name":"Toast","sourcePath":"components/feedback/Toast.jsx"},{"name":"BackgroundEditor","sourcePath":"ui_kits/productcam-app/BackgroundEditor.jsx"},{"name":"BatchSession","sourcePath":"ui_kits/productcam-app/BatchSession.jsx"},{"name":"CameraCapture","sourcePath":"ui_kits/productcam-app/CameraCapture.jsx"},{"name":"ExportSheet","sourcePath":"ui_kits/productcam-app/ExportSheet.jsx"},{"name":"History","sourcePath":"ui_kits/productcam-app/History.jsx"},{"name":"ProcessingReview","sourcePath":"ui_kits/productcam-app/ProcessingReview.jsx"},{"name":"PhoneFrame","sourcePath":"ui_kits/productcam-app/Shell.jsx"},{"name":"StatusBar","sourcePath":"ui_kits/productcam-app/Shell.jsx"},{"name":"HomeIndicator","sourcePath":"ui_kits/productcam-app/Shell.jsx"},{"name":"ScreenHeader","sourcePath":"ui_kits/productcam-app/Shell.jsx"},{"name":"FeedStub","sourcePath":"ui_kits/productcam-app/Shell.jsx"},{"name":"ThumbBand","sourcePath":"ui_kits/productcam-app/Shell.jsx"},{"name":"PC_SHOTS","sourcePath":"ui_kits/productcam-app/Shell.jsx"}],"sourceHashes":{"components/batch/BatchThumb.jsx":"a76400f3efcb","components/batch/ProgressTrace.jsx":"5b70afa3e9d1","components/camera/ContourOverlay.jsx":"def07c79cf63","components/camera/ModeToggle.jsx":"cb8bc0748e41","components/camera/Readout.jsx":"735834489eef","components/camera/ShutterButton.jsx":"0cc96700b342","components/core/Badge.jsx":"90d81103f162","components/core/Button.jsx":"40970071ab52","components/core/Chip.jsx":"053d68161f63","components/core/Icon.jsx":"b74373586947","components/core/IconButton.jsx":"60cab3dd9542","components/core/Sheet.jsx":"266d3872149b","components/editor/BackgroundSwatchPicker.jsx":"279923933126","components/editor/CheckerSurface.jsx":"68b3eb4f460e","components/editor/Slider.jsx":"8d3cd984566c","components/feedback/EdgeNotice.jsx":"a158105997d6","components/feedback/Toast.jsx":"f16685d38774","ui_kits/productcam-app/BackgroundEditor.jsx":"54edb4077264","ui_kits/productcam-app/BatchSession.jsx":"895380e514dd","ui_kits/productcam-app/CameraCapture.jsx":"792b967af96b","ui_kits/productcam-app/ExportSheet.jsx":"555a1d4fbd78","ui_kits/productcam-app/History.jsx":"613c3c19761c","ui_kits/productcam-app/ProcessingReview.jsx":"a84044991054","ui_kits/productcam-app/Shell.jsx":"0ca7403fd8d3"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.ProductCamDesignSystem_8d7e15 = window.ProductCamDesignSystem_8d7e15 || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// components/batch/ProgressTrace.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/* Progress drawn as a traced ring - the contour motif applied to time.
   Same language as the viewfinder: a line being drawn around the subject. */
function ProgressTrace({
  value = 0,
  size = 44,
  thickness = 3,
  tone = 'accent',
  label,
  indeterminate,
  style,
  ...rest
}) {
  const r = (size - thickness) / 2;
  const c = 2 * Math.PI * r;
  const stroke = tone === 'caution' ? 'var(--amber-500)' : tone === 'danger' ? 'var(--coral-500)' : 'var(--mint-400)';
  const pct = Math.max(0, Math.min(100, value));
  return /*#__PURE__*/React.createElement("span", _extends({
    style: {
      position: 'relative',
      width: size,
      height: size,
      display: 'grid',
      placeItems: 'center',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("svg", {
    width: size,
    height: size,
    viewBox: '0 0 ' + size + ' ' + size,
    style: {
      position: 'absolute',
      inset: 0,
      transform: 'rotate(-90deg)',
      animation: indeterminate ? 'pc-trace-spin 1s linear infinite' : undefined
    }
  }, /*#__PURE__*/React.createElement("circle", {
    cx: size / 2,
    cy: size / 2,
    r: r,
    fill: "none",
    stroke: "var(--alpha-white-14)",
    strokeWidth: thickness
  }), /*#__PURE__*/React.createElement("circle", {
    cx: size / 2,
    cy: size / 2,
    r: r,
    fill: "none",
    stroke: stroke,
    strokeWidth: thickness,
    strokeLinecap: "round",
    strokeDasharray: indeterminate ? c * 0.3 + ' ' + c : c * pct / 100 + ' ' + c,
    style: {
      transition: indeterminate ? undefined : 'stroke-dasharray var(--dur-base) var(--ease-out)',
      filter: 'var(--contour-glow)'
    }
  })), label !== false ? /*#__PURE__*/React.createElement("span", {
    style: {
      font: 'var(--type-readout-sm)',
      letterSpacing: 'var(--tracking-readout)',
      color: 'var(--text-primary)'
    }
  }, label != null ? label : indeterminate ? '' : Math.round(pct)) : null);
}
Object.assign(__ds_scope, { ProgressTrace });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/batch/ProgressTrace.jsx", error: String((e && e.message) || e) }); }

// components/camera/ContourOverlay.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/* THE SIGNATURE ELEMENT.
   Two strokes, always: a dark halo underneath and a mint core on top, so the
   contour reads on a white sweep, black leather, or a backlit window alike.
   State is carried by dash pattern + motion, never by hue alone. */
const CONTOUR_SHAPES = {
  box: {
    d: 'M22 31 L78 31 L82 75 Q82 82 75 82 L25 82 Q18 82 18 75 Z',
    box: [18, 31, 64, 51]
  },
  bottle: {
    d: 'M45 11 h10 v9 c0 5 8 8 8 19 v39 c0 6-4 9-9 9 h-8 c-5 0-9-3-9-9 v-39 c0-11 8-14 8-19 z',
    box: [37, 11, 26, 76]
  },
  bag: {
    d: 'M30 36 c0-11 7-18 20-18 s20 7 20 18 l4 46 h-48 z',
    box: [26, 18, 48, 64]
  },
  shoe: {
    d: 'M20 68 c0-8 6-10 14-14 c8-4 12-14 20-14 c6 0 8 5 10 10 c2 6 12 8 16 14 c3 4 2 10-4 10 h-50 c-4 0-6-3-6-6 z',
    box: [20, 40, 60, 34]
  }
};
const pcContourColors = {
  scanning: {
    core: 'var(--contour-core)',
    dash: 'var(--contour-dash-scan)',
    fill: 'var(--contour-fill-scan)',
    glow: 'var(--contour-glow)',
    w: 'var(--contour-w-core)'
  },
  locked: {
    core: 'var(--contour-core-lock)',
    dash: 'none',
    fill: 'var(--contour-fill-lock)',
    glow: 'var(--contour-glow)',
    w: 'var(--contour-w-core-lock)'
  },
  review: {
    core: 'var(--contour-review)',
    dash: 'var(--contour-dash-review)',
    fill: 'transparent',
    glow: 'var(--contour-glow-review)',
    w: 'var(--contour-w-core)'
  }
};
function ContourOverlay({
  state = 'scanning',
  shape = 'box',
  path,
  bbox,
  ticks = true,
  sweep = true,
  stretch = false,
  style,
  ...rest
}) {
  const uid = React.useId().replace(/[^a-zA-Z0-9]/g, '');
  const preset = CONTOUR_SHAPES[shape] || CONTOUR_SHAPES.box;
  const d = path || preset.d;
  const [bx, by, bw, bh] = bbox || preset.box;
  const s = pcContourColors[state] || pcContourColors.scanning;
  const corner = (cx, cy, sx, sy) => /*#__PURE__*/React.createElement("g", {
    key: cx + '-' + cy,
    stroke: state === 'review' ? 'var(--contour-review)' : 'var(--contour-core)',
    strokeWidth: "var(--contour-tick-w)",
    strokeLinecap: "square",
    vectorEffect: "non-scaling-stroke",
    opacity: state === 'locked' ? 1 : 0.75
  }, /*#__PURE__*/React.createElement("line", {
    x1: cx,
    y1: cy,
    x2: cx + sx * 5,
    y2: cy
  }), /*#__PURE__*/React.createElement("line", {
    x1: cx,
    y1: cy,
    x2: cx,
    y2: cy + sy * 5
  }));
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      position: 'absolute',
      inset: 0,
      pointerEvents: 'none',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("svg", {
    viewBox: "0 0 100 100",
    preserveAspectRatio: stretch ? 'none' : 'xMidYMid meet',
    width: "100%",
    height: "100%",
    style: {
      display: 'block',
      overflow: 'visible'
    }
  }, /*#__PURE__*/React.createElement("defs", null, /*#__PURE__*/React.createElement("clipPath", {
    id: 'clip' + uid
  }, /*#__PURE__*/React.createElement("path", {
    d: d
  })), /*#__PURE__*/React.createElement("linearGradient", {
    id: 'sweep' + uid,
    x1: "0",
    y1: "0",
    x2: "0",
    y2: "1"
  }, /*#__PURE__*/React.createElement("stop", {
    offset: "0%",
    stopColor: "var(--mint-500)",
    stopOpacity: "0"
  }), /*#__PURE__*/React.createElement("stop", {
    offset: "55%",
    stopColor: "var(--mint-400)",
    stopOpacity: ".55"
  }), /*#__PURE__*/React.createElement("stop", {
    offset: "100%",
    stopColor: "var(--mint-500)",
    stopOpacity: "0"
  }))), /*#__PURE__*/React.createElement("path", {
    d: d,
    fill: s.fill,
    stroke: "var(--contour-halo)",
    strokeWidth: "var(--contour-w-halo)",
    strokeLinejoin: "round",
    vectorEffect: "non-scaling-stroke"
  }), sweep && state === 'scanning' ? /*#__PURE__*/React.createElement("g", {
    clipPath: 'url(#clip' + uid + ')'
  }, /*#__PURE__*/React.createElement("rect", {
    x: "0",
    y: "0",
    width: "100",
    height: "26",
    fill: 'url(#sweep' + uid + ')',
    style: {
      animation: 'pc-sweep var(--dur-trace) var(--ease-in-out) infinite'
    }
  })) : null, /*#__PURE__*/React.createElement("path", {
    d: d,
    fill: "none",
    stroke: s.core,
    strokeWidth: s.w,
    strokeLinejoin: "round",
    vectorEffect: "non-scaling-stroke",
    strokeDasharray: s.dash === 'none' ? undefined : s.dash,
    style: {
      filter: s.glow,
      animation: state === 'scanning' ? 'pc-march var(--dur-trace) linear infinite' : undefined
    }
  }), state === 'locked' ? /*#__PURE__*/React.createElement("path", {
    d: d,
    fill: "none",
    stroke: "var(--contour-core)",
    strokeWidth: "var(--contour-w-halo)",
    vectorEffect: "non-scaling-stroke",
    style: {
      transformOrigin: 'center',
      animation: 'pc-lock-pulse var(--dur-slow) var(--ease-out) 1 forwards'
    }
  }) : null, ticks ? [corner(bx - 2, by - 2, 1, 1), corner(bx + bw + 2, by - 2, -1, 1), corner(bx - 2, by + bh + 2, 1, -1), corner(bx + bw + 2, by + bh + 2, -1, -1)] : null));
}
Object.assign(__ds_scope, { CONTOUR_SHAPES, ContourOverlay });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/camera/ContourOverlay.jsx", error: String((e && e.message) || e) }); }

// components/camera/ShutterButton.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/* Optimised for the most repeated action in the app: pressed one-handed, without
   looking, dozens of times in a batch session. 80px visible, 104px hit target,
   parked inside the bottom thumb band. */
const pcShutterRing = {
  ready: 'rgba(255,255,255,.72)',
  locked: 'var(--mint-500)',
  busy: 'var(--mint-600)',
  disabled: 'var(--ink-500)'
};
function ShutterButton({
  state = 'ready',
  count,
  onCapture,
  onLongPress,
  label = 'Chụp',
  style,
  ...rest
}) {
  const [down, setDown] = React.useState(false);
  const timer = React.useRef(null);
  const off = state === 'disabled' || state === 'busy';
  const start = () => {
    if (off) return;
    setDown(true);
    if (onLongPress) timer.current = setTimeout(onLongPress, 420);
  };
  const end = () => {
    setDown(false);
    if (timer.current) clearTimeout(timer.current);
  };
  return /*#__PURE__*/React.createElement("button", _extends({
    type: "button",
    "aria-label": label,
    disabled: off,
    onClick: off ? undefined : onCapture,
    onPointerDown: start,
    onPointerUp: end,
    onPointerLeave: end,
    onPointerCancel: end,
    style: {
      width: 'var(--touch-shutter-hit)',
      height: 'var(--touch-shutter-hit)',
      border: 'none',
      background: 'transparent',
      padding: 0,
      display: 'grid',
      placeItems: 'center',
      cursor: off ? 'default' : 'pointer',
      WebkitTapHighlightColor: 'transparent',
      touchAction: 'manipulation',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'relative',
      width: 'var(--touch-shutter)',
      height: 'var(--touch-shutter)',
      borderRadius: '50%',
      display: 'grid',
      placeItems: 'center',
      border: '3px solid ' + pcShutterRing[state],
      boxShadow: state === 'locked' ? 'var(--glow-accent)' : '0 2px 14px rgba(2,8,14,.5)',
      transition: 'border-color var(--dur-lock) var(--ease-out), box-shadow var(--dur-lock) var(--ease-out), transform var(--dur-shutter) var(--ease-snap)',
      transform: down ? 'scale(var(--press-scale-shutter))' : 'none'
    }
  }, state === 'busy' ? /*#__PURE__*/React.createElement("svg", {
    viewBox: "0 0 44 44",
    width: "44",
    height: "44",
    style: {
      animation: 'pc-trace-spin 900ms linear infinite'
    }
  }, /*#__PURE__*/React.createElement("circle", {
    cx: "22",
    cy: "22",
    r: "19",
    fill: "none",
    stroke: "var(--alpha-white-14)",
    strokeWidth: "3"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "22",
    cy: "22",
    r: "19",
    fill: "none",
    stroke: "var(--mint-400)",
    strokeWidth: "3",
    strokeLinecap: "round",
    strokeDasharray: "34 86"
  })) : /*#__PURE__*/React.createElement("span", {
    style: {
      width: 60,
      height: 60,
      borderRadius: '50%',
      background: state === 'locked' ? 'var(--contour-core-lock)' : state === 'disabled' ? 'var(--ink-600)' : 'var(--white)',
      display: 'grid',
      placeItems: 'center',
      font: 'var(--type-readout)',
      letterSpacing: 'var(--tracking-readout)',
      color: 'var(--ink-900)',
      transition: 'background-color var(--dur-lock) var(--ease-out), transform var(--dur-shutter) var(--ease-snap)',
      transform: down ? 'scale(.92)' : 'none'
    }
  }, count != null ? count : '')));
}
Object.assign(__ds_scope, { ShutterButton });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/camera/ShutterButton.jsx", error: String((e && e.message) || e) }); }

// components/core/Icon.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/* Lucide (CDN, pinned) is ProductCam's icon set. Every page using Icon must load
   the UMD build first: unpkg.com/lucide@0.474.0/dist/umd/lucide.min.js
   Icon only wraps that set - it never draws its own glyphs. */
function lookup(name) {
  const L = typeof window !== 'undefined' ? window.lucide : null;
  if (!L || !L.icons) return null;
  const pascal = String(name).replace(/(^|-)([a-z0-9])/g, (m, a, b) => b.toUpperCase());
  return L.icons[pascal] || L.icons[name] || null;
}
function toEl(node, i) {
  if (!Array.isArray(node)) return null;
  const [tag, attrs, kids] = node;
  return React.createElement(tag, {
    key: i,
    ...(attrs || {})
  }, Array.isArray(kids) ? kids.map(toEl) : null);
}
function children(node) {
  if (!Array.isArray(node)) return [];
  if (typeof node[0] === 'string') return node[0] === 'svg' ? node[2] || [] : [node];
  return node;
}
function Icon({
  name,
  size = 22,
  strokeWidth = 1.75,
  color = 'currentColor',
  style,
  title,
  ...rest
}) {
  const [, tick] = React.useReducer(n => n + 1, 0);
  const node = lookup(name);
  React.useEffect(() => {
    if (node) return;
    const id = setInterval(() => {
      if (lookup(name)) {
        clearInterval(id);
        tick();
      }
    }, 90);
    const stop = setTimeout(() => clearInterval(id), 5000);
    return () => {
      clearInterval(id);
      clearTimeout(stop);
    };
  }, [name, node]);
  return /*#__PURE__*/React.createElement("svg", _extends({
    viewBox: "0 0 24 24",
    width: size,
    height: size,
    fill: "none",
    stroke: color,
    strokeWidth: strokeWidth,
    strokeLinecap: "round",
    strokeLinejoin: "round",
    "aria-hidden": title ? undefined : 'true',
    role: title ? 'img' : undefined,
    style: {
      display: 'block',
      flex: '0 0 auto',
      ...style
    }
  }, rest), title ? /*#__PURE__*/React.createElement("title", null, title) : null, children(node).map(toEl));
}
Object.assign(__ds_scope, { Icon });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Icon.jsx", error: String((e && e.message) || e) }); }

// components/camera/ModeToggle.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
function ModeToggle({
  value = 'single',
  onChange,
  options,
  style,
  ...rest
}) {
  const opts = options || [{
    id: 'single',
    label: 'Đơn',
    icon: 'image'
  }, {
    id: 'batch',
    label: 'Loạt',
    icon: 'layers'
  }];
  const i = Math.max(0, opts.findIndex(o => o.id === value));
  return /*#__PURE__*/React.createElement("div", _extends({
    role: "tablist",
    style: {
      position: 'relative',
      display: 'inline-grid',
      gridAutoFlow: 'column',
      gridAutoColumns: '1fr',
      padding: 3,
      gap: 2,
      borderRadius: 'var(--r-pill)',
      background: 'var(--bg-glass)',
      backdropFilter: 'var(--blur-chrome)',
      border: '1px solid var(--border-subtle)',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      top: 3,
      bottom: 3,
      left: 3,
      width: 'calc((100% - 6px) / ' + opts.length + ')',
      transform: 'translateX(' + i * 100 + '%)',
      borderRadius: 'var(--r-pill)',
      background: 'var(--accent)',
      transition: 'transform var(--dur-base) var(--ease-snap)'
    }
  }), opts.map(o => {
    const on = o.id === value;
    return /*#__PURE__*/React.createElement("button", {
      key: o.id,
      type: "button",
      role: "tab",
      "aria-selected": on,
      onClick: () => onChange && onChange(o.id),
      style: {
        position: 'relative',
        height: 38,
        minWidth: 78,
        padding: '0 var(--sp-6)',
        border: 'none',
        background: 'transparent',
        borderRadius: 'var(--r-pill)',
        cursor: 'pointer',
        display: 'inline-flex',
        alignItems: 'center',
        justifyContent: 'center',
        gap: 'var(--sp-3)',
        color: on ? 'var(--text-on-accent)' : 'var(--text-secondary)',
        font: 'var(--type-button)',
        fontSize: 'var(--fs-body-sm)',
        transition: 'color var(--dur-fast) var(--ease-out)',
        WebkitTapHighlightColor: 'transparent'
      }
    }, o.icon ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
      name: o.icon,
      size: 16
    }) : null, o.label);
  }));
}
Object.assign(__ds_scope, { ModeToggle });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/camera/ModeToggle.jsx", error: String((e && e.message) || e) }); }

// components/camera/Readout.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const pcReadoutTones = {
  idle: ['var(--text-secondary)', 'var(--ink-400)'],
  scanning: ['var(--text-primary)', 'var(--mint-400)'],
  locked: ['var(--mint-050)', 'var(--mint-500)'],
  review: ['var(--amber-050)', 'var(--amber-500)'],
  error: ['var(--coral-050)', 'var(--coral-500)']
};
function Readout({
  state = 'scanning',
  children,
  meta,
  icon,
  style,
  ...rest
}) {
  const tone = pcReadoutTones[state] || pcReadoutTones.idle;
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 'var(--sp-4)',
      height: 30,
      padding: '0 var(--sp-5)',
      borderRadius: 'var(--r-pill)',
      background: 'var(--bg-glass)',
      backdropFilter: 'var(--blur-chrome)',
      border: '1px solid var(--border-hairline)',
      color: tone[0],
      font: 'var(--type-readout)',
      letterSpacing: 'var(--tracking-readout)',
      textTransform: 'uppercase',
      whiteSpace: 'nowrap',
      ...style
    }
  }, rest), icon ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: 14
  }) : /*#__PURE__*/React.createElement("span", {
    style: {
      width: 7,
      height: 7,
      borderRadius: '50%',
      background: tone[1],
      flex: '0 0 auto',
      boxShadow: state === 'locked' ? '0 0 8px var(--mint-500)' : 'none',
      animation: state === 'scanning' ? 'pc-lock-pulse 1.1s var(--ease-in-out) infinite alternate' : undefined
    }
  }), /*#__PURE__*/React.createElement("span", null, children), meta ? /*#__PURE__*/React.createElement("span", {
    style: {
      color: 'var(--text-muted)'
    }
  }, "\xB7 ", meta) : null);
}
Object.assign(__ds_scope, { Readout });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/camera/Readout.jsx", error: String((e && e.message) || e) }); }

// components/core/Badge.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const pcBadgeTones = {
  neutral: ['var(--alpha-white-08)', 'var(--text-secondary)', 'var(--ink-400)'],
  accent: ['var(--accent-quiet)', 'var(--text-accent)', 'var(--mint-500)'],
  caution: ['var(--caution-quiet)', 'var(--text-caution)', 'var(--amber-500)'],
  danger: ['var(--danger-quiet)', 'var(--text-danger)', 'var(--coral-500)'],
  solid: ['var(--accent)', 'var(--text-on-accent)', 'var(--ink-950)']
};
function Badge({
  children,
  tone = 'neutral',
  dot,
  icon,
  style,
  ...rest
}) {
  const [bg, fg, dotColor] = pcBadgeTones[tone];
  return /*#__PURE__*/React.createElement("span", _extends({
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 'var(--sp-3)',
      height: 24,
      padding: '0 var(--sp-5)',
      borderRadius: 'var(--r-pill)',
      background: bg,
      color: fg,
      font: 'var(--type-readout-sm)',
      letterSpacing: 'var(--tracking-readout)',
      textTransform: 'uppercase',
      ...style
    }
  }, rest), dot ? /*#__PURE__*/React.createElement("span", {
    style: {
      width: 6,
      height: 6,
      borderRadius: '50%',
      background: dotColor,
      flex: '0 0 auto'
    }
  }) : null, icon ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: 13
  }) : null, children);
}
Object.assign(__ds_scope, { Badge });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Badge.jsx", error: String((e && e.message) || e) }); }

// components/core/Button.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const pcBtnBase = {
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  gap: 'var(--sp-4)',
  border: '1px solid transparent',
  borderRadius: 'var(--r-pill)',
  font: 'var(--type-button)',
  letterSpacing: 'var(--tracking-tight)',
  cursor: 'pointer',
  transition: 'var(--t-color), var(--t-press)',
  WebkitTapHighlightColor: 'transparent',
  userSelect: 'none',
  whiteSpace: 'nowrap'
};
const pcBtnSizes = {
  sm: {
    height: 40,
    padding: '0 var(--sp-6)',
    fontSize: 'var(--fs-body-sm)'
  },
  md: {
    height: 48,
    padding: '0 var(--sp-7)',
    fontSize: 'var(--fs-body)'
  },
  lg: {
    height: 56,
    padding: '0 var(--sp-9)',
    fontSize: 'var(--fs-body-lg)'
  }
};
const pcBtnVariants = {
  primary: {
    background: 'var(--accent)',
    color: 'var(--text-on-accent)',
    boxShadow: 'var(--glow-accent-soft)'
  },
  secondary: {
    background: 'var(--bg-surface-raised)',
    color: 'var(--text-primary)',
    borderColor: 'var(--border-subtle)'
  },
  ghost: {
    background: 'transparent',
    color: 'var(--text-accent)'
  },
  glass: {
    background: 'var(--bg-glass)',
    color: 'var(--text-primary)',
    borderColor: 'var(--border-subtle)',
    backdropFilter: 'var(--blur-chrome)'
  },
  caution: {
    background: 'var(--caution-quiet)',
    color: 'var(--text-caution)',
    borderColor: 'rgba(255,176,32,.4)'
  },
  danger: {
    background: 'var(--danger-quiet)',
    color: 'var(--text-danger)',
    borderColor: 'rgba(255,90,95,.4)'
  }
};
const pcBtnPress = {
  primary: {
    background: 'var(--accent-press)'
  },
  secondary: {
    background: 'var(--ink-700)'
  },
  ghost: {
    background: 'var(--accent-quiet)'
  },
  glass: {
    background: 'rgba(18,34,50,.8)'
  },
  caution: {
    background: 'rgba(255,176,32,.26)'
  },
  danger: {
    background: 'rgba(255,90,95,.26)'
  }
};
function Button({
  children,
  variant = 'primary',
  size = 'md',
  iconLeft,
  iconRight,
  fullWidth,
  loading,
  disabled,
  onClick,
  style,
  type = 'button',
  ...rest
}) {
  const [down, setDown] = React.useState(false);
  const off = disabled || loading;
  const iconSize = size === 'lg' ? 22 : size === 'sm' ? 17 : 20;
  return /*#__PURE__*/React.createElement("button", _extends({
    type: type,
    disabled: off,
    onClick: onClick,
    onPointerDown: () => !off && setDown(true),
    onPointerUp: () => setDown(false),
    onPointerLeave: () => setDown(false),
    style: {
      ...pcBtnBase,
      ...pcBtnSizes[size],
      ...pcBtnVariants[variant],
      ...(down ? pcBtnPress[variant] : null),
      width: fullWidth ? '100%' : undefined,
      transform: down ? 'scale(var(--press-scale))' : 'none',
      opacity: off ? 0.42 : 1,
      cursor: off ? 'not-allowed' : 'pointer',
      ...style
    }
  }, rest), loading ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: "loader",
    size: iconSize,
    style: {
      animation: 'pc-trace-spin 900ms linear infinite'
    }
  }) : iconLeft ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: iconLeft,
    size: iconSize
  }) : null, children, iconRight && !loading ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: iconRight,
    size: iconSize
  }) : null);
}
Object.assign(__ds_scope, { Button });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Button.jsx", error: String((e && e.message) || e) }); }

// components/core/Chip.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
function Chip({
  children,
  icon,
  selected,
  size = 'md',
  tone = 'default',
  onClick,
  style,
  ...rest
}) {
  const [down, setDown] = React.useState(false);
  const h = size === 'sm' ? 32 : 40;
  const toneSel = tone === 'caution' ? {
    background: 'var(--caution-quiet)',
    color: 'var(--text-caution)',
    borderColor: 'rgba(255,176,32,.45)'
  } : {
    background: 'var(--accent-quiet-strong)',
    color: 'var(--text-accent)',
    borderColor: 'var(--border-accent)'
  };
  return /*#__PURE__*/React.createElement("button", _extends({
    type: "button",
    role: "radio",
    "aria-checked": !!selected,
    onClick: onClick,
    onPointerDown: () => setDown(true),
    onPointerUp: () => setDown(false),
    onPointerLeave: () => setDown(false),
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 'var(--sp-3)',
      height: h,
      padding: size === 'sm' ? '0 var(--sp-5)' : '0 var(--sp-6)',
      borderRadius: 'var(--r-pill)',
      border: '1px solid var(--border-hairline)',
      background: 'var(--bg-surface-raised)',
      color: 'var(--text-secondary)',
      font: 'var(--type-caption)',
      fontSize: size === 'sm' ? 'var(--fs-micro)' : 'var(--fs-body-sm)',
      fontWeight: 'var(--fw-semibold)',
      cursor: 'pointer',
      transition: 'var(--t-color), var(--t-press)',
      transform: down ? 'scale(var(--press-scale))' : 'none',
      WebkitTapHighlightColor: 'transparent',
      ...(selected ? toneSel : null),
      ...style
    }
  }, rest), icon ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: size === 'sm' ? 14 : 16
  }) : null, children);
}
Object.assign(__ds_scope, { Chip });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Chip.jsx", error: String((e && e.message) || e) }); }

// components/core/IconButton.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const pcIbSizes = {
  sm: 36,
  md: 44,
  lg: 56
};
const pcIbVariants = {
  glass: {
    background: 'var(--bg-glass)',
    color: 'var(--text-primary)',
    border: '1px solid var(--border-subtle)',
    backdropFilter: 'var(--blur-chrome)'
  },
  solid: {
    background: 'var(--bg-surface-raised)',
    color: 'var(--text-primary)',
    border: '1px solid var(--border-hairline)'
  },
  ghost: {
    background: 'transparent',
    color: 'var(--text-secondary)',
    border: '1px solid transparent'
  },
  accent: {
    background: 'var(--accent)',
    color: 'var(--text-on-accent)',
    border: '1px solid transparent',
    boxShadow: 'var(--glow-accent-soft)'
  }
};
function IconButton({
  icon,
  label,
  size = 'md',
  variant = 'glass',
  active,
  badge,
  disabled,
  onClick,
  style,
  ...rest
}) {
  const [down, setDown] = React.useState(false);
  const px = pcIbSizes[size];
  return /*#__PURE__*/React.createElement("button", _extends({
    type: "button",
    "aria-label": label,
    "aria-pressed": active,
    disabled: disabled,
    onClick: onClick,
    onPointerDown: () => !disabled && setDown(true),
    onPointerUp: () => setDown(false),
    onPointerLeave: () => setDown(false),
    style: {
      position: 'relative',
      width: px,
      height: px,
      minWidth: px,
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      borderRadius: 'var(--r-pill)',
      cursor: disabled ? 'not-allowed' : 'pointer',
      opacity: disabled ? 0.4 : 1,
      transition: 'var(--t-color), var(--t-press)',
      WebkitTapHighlightColor: 'transparent',
      transform: down ? 'scale(var(--press-scale))' : 'none',
      ...pcIbVariants[variant],
      ...(active ? {
        background: 'var(--accent-quiet-strong)',
        color: 'var(--text-accent)',
        borderColor: 'var(--border-accent)'
      } : null),
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: size === 'lg' ? 26 : size === 'sm' ? 18 : 22
  }), badge != null ? /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      top: -3,
      right: -3,
      minWidth: 18,
      height: 18,
      padding: '0 5px',
      display: 'grid',
      placeItems: 'center',
      borderRadius: 'var(--r-pill)',
      background: 'var(--accent)',
      color: 'var(--text-on-accent)',
      font: 'var(--type-readout-sm)',
      border: '2px solid var(--bg-shell)'
    }
  }, badge) : null);
}
Object.assign(__ds_scope, { IconButton });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/IconButton.jsx", error: String((e && e.message) || e) }); }

// components/core/Sheet.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
function Sheet({
  title,
  subtitle,
  children,
  footer,
  onClose,
  handle = true,
  tone = 'default',
  style,
  ...rest
}) {
  return /*#__PURE__*/React.createElement("section", _extends({
    style: {
      position: 'relative',
      width: '100%',
      background: 'var(--bg-sheet)',
      borderTopLeftRadius: 'var(--r-sheet)',
      borderTopRightRadius: 'var(--r-sheet)',
      boxShadow: 'var(--shadow-sheet), var(--rim)',
      padding: 'var(--sheet-pad)',
      paddingBottom: 'calc(var(--sheet-pad) + var(--safe-bottom))',
      borderTop: tone === 'accent' ? '1px solid var(--border-accent)' : 'none',
      animation: 'pc-fade-up var(--dur-base) var(--ease-out)',
      ...style
    }
  }, rest), handle ? /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      top: 8,
      left: '50%',
      transform: 'translateX(-50%)',
      width: 40,
      height: 4,
      borderRadius: 'var(--r-pill)',
      background: 'var(--alpha-white-14)'
    }
  }) : null, title || onClose ? /*#__PURE__*/React.createElement("header", {
    style: {
      display: 'flex',
      alignItems: 'flex-start',
      gap: 'var(--sp-5)',
      marginBottom: 'var(--sp-6)',
      marginTop: handle ? 'var(--sp-3)' : 0
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      minWidth: 0
    }
  }, title ? /*#__PURE__*/React.createElement("h2", {
    style: {
      font: 'var(--type-h3)',
      color: 'var(--text-primary)'
    }
  }, title) : null, subtitle ? /*#__PURE__*/React.createElement("p", {
    style: {
      font: 'var(--type-caption)',
      color: 'var(--text-muted)',
      marginTop: 'var(--sp-2)'
    }
  }, subtitle) : null), onClose ? /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    icon: "x",
    label: "\u0110\xF3ng",
    size: "sm",
    variant: "ghost",
    onClick: onClose
  }) : null) : null, children, footer ? /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 'var(--sp-7)',
      display: 'flex',
      gap: 'var(--sp-5)'
    }
  }, footer) : null);
}
Object.assign(__ds_scope, { Sheet });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/core/Sheet.jsx", error: String((e && e.message) || e) }); }

// components/editor/BackgroundSwatchPicker.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const PC_BACKGROUNDS = [{
  id: 'transparent',
  label: 'Trong suốt',
  type: 'checker'
}, {
  id: 'white',
  label: 'Trắng',
  type: 'color',
  value: '#FFFFFF'
}, {
  id: 'ivory',
  label: 'Kem',
  type: 'color',
  value: '#F3EFE6'
}, {
  id: 'stone',
  label: 'Xám',
  type: 'color',
  value: '#E4E9EC'
}, {
  id: 'grad-mint',
  label: 'Mint',
  type: 'gradient',
  value: 'linear-gradient(160deg,#E4FFF9,#9DF7E5)'
}, {
  id: 'grad-warm',
  label: 'Nắng',
  type: 'gradient',
  value: 'linear-gradient(160deg,#FFF4DE,#FFD48A)'
}, {
  id: 'ink',
  label: 'Đậm',
  type: 'color',
  value: '#12202F'
}];
function BackgroundSwatchPicker({
  options = PC_BACKGROUNDS,
  value,
  onChange,
  size = 56,
  showLabels = true,
  style,
  ...rest
}) {
  return /*#__PURE__*/React.createElement("div", _extends({
    role: "radiogroup",
    style: {
      display: 'flex',
      gap: 'var(--sp-5)',
      overflowX: 'auto',
      paddingBottom: 'var(--sp-2)',
      scrollbarWidth: 'none',
      ...style
    }
  }, rest), options.map(o => {
    const on = o.id === value;
    const bg = o.type === 'checker' ? 'var(--checker-light)' : o.value;
    return /*#__PURE__*/React.createElement("button", {
      key: o.id,
      type: "button",
      role: "radio",
      "aria-checked": on,
      "aria-label": o.label,
      onClick: () => onChange && onChange(o.id),
      style: {
        flex: '0 0 auto',
        border: 'none',
        background: 'transparent',
        padding: 0,
        cursor: 'pointer',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        gap: 'var(--sp-3)',
        WebkitTapHighlightColor: 'transparent'
      }
    }, /*#__PURE__*/React.createElement("span", {
      style: {
        position: 'relative',
        width: size,
        height: size,
        borderRadius: 'var(--r-sm)',
        background: bg,
        boxShadow: on ? '0 0 0 2px var(--bg-app), 0 0 0 4px var(--contour-core), var(--glow-accent-soft)' : 'inset 0 0 0 1px var(--border-subtle)',
        transition: 'box-shadow var(--dur-fast) var(--ease-out)',
        display: 'grid',
        placeItems: 'center'
      }
    }, o.type === 'custom' ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
      name: "plus",
      size: 20,
      color: "var(--text-secondary)"
    }) : null, on ? /*#__PURE__*/React.createElement("span", {
      style: {
        position: 'absolute',
        right: -4,
        bottom: -4,
        width: 18,
        height: 18,
        borderRadius: '50%',
        background: 'var(--contour-core)',
        display: 'grid',
        placeItems: 'center',
        border: '2px solid var(--bg-app)'
      }
    }, /*#__PURE__*/React.createElement(__ds_scope.Icon, {
      name: "check",
      size: 11,
      color: "var(--ink-950)",
      strokeWidth: 3
    })) : null), showLabels ? /*#__PURE__*/React.createElement("span", {
      style: {
        font: 'var(--type-readout-sm)',
        letterSpacing: 'var(--tracking-label)',
        textTransform: 'uppercase',
        color: on ? 'var(--text-accent)' : 'var(--text-muted)'
      }
    }, o.label) : null);
  }));
}
Object.assign(__ds_scope, { PC_BACKGROUNDS, BackgroundSwatchPicker });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/editor/BackgroundSwatchPicker.jsx", error: String((e && e.message) || e) }); }

// components/editor/CheckerSurface.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/* Transparency is shown the way every seller already knows it from other tools:
   a checkerboard. Do not invent another symbol for "no background". */
function CheckerSurface({
  children,
  tone = 'light',
  radius = 'var(--r-md)',
  pad = 0,
  style,
  ...rest
}) {
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      position: 'relative',
      background: tone === 'dark' ? 'var(--checker-dark)' : 'var(--checker-light)',
      borderRadius: radius,
      padding: pad,
      boxShadow: 'var(--rim)',
      overflow: 'hidden',
      display: 'grid',
      placeItems: 'center',
      ...style
    }
  }, rest), children);
}
Object.assign(__ds_scope, { CheckerSurface });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/editor/CheckerSurface.jsx", error: String((e && e.message) || e) }); }

// components/batch/BatchThumb.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const pcThumbStatus = {
  queued: {
    color: 'var(--status-queued)',
    icon: 'clock',
    text: 'CHỜ'
  },
  working: {
    color: 'var(--status-working)',
    icon: null,
    text: null
  },
  done: {
    color: 'var(--status-done)',
    icon: 'check',
    text: null
  },
  review: {
    color: 'var(--status-review)',
    icon: 'scissors',
    text: null
  },
  error: {
    color: 'var(--status-error)',
    icon: 'rotate-cw',
    text: 'LỖI'
  }
};
function BatchThumb({
  index,
  status = 'done',
  progress = 0,
  src,
  shape = 'box',
  selected,
  onClick,
  style,
  ...rest
}) {
  const s = pcThumbStatus[status] || pcThumbStatus.done;
  return /*#__PURE__*/React.createElement("button", _extends({
    type: "button",
    onClick: onClick,
    "aria-label": 'Ảnh ' + (index != null ? index : ''),
    style: {
      position: 'relative',
      width: '100%',
      aspectRatio: '1 / 1',
      padding: 0,
      border: 'none',
      borderRadius: 'var(--r-thumb)',
      overflow: 'hidden',
      cursor: 'pointer',
      background: 'transparent',
      boxShadow: selected ? '0 0 0 2px var(--bg-app), 0 0 0 4px var(--contour-core)' : 'none',
      transition: 'box-shadow var(--dur-fast) var(--ease-out)',
      WebkitTapHighlightColor: 'transparent',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement(__ds_scope.CheckerSurface, {
    radius: "var(--r-thumb)",
    style: {
      position: 'absolute',
      inset: 0
    }
  }, src ? /*#__PURE__*/React.createElement("img", {
    src: src,
    alt: "",
    style: {
      width: '100%',
      height: '100%',
      objectFit: 'contain'
    }
  }) : /*#__PURE__*/React.createElement("svg", {
    viewBox: "0 0 100 100",
    width: "82%",
    height: "82%",
    preserveAspectRatio: "xMidYMid meet",
    "aria-hidden": "true"
  }, /*#__PURE__*/React.createElement("path", {
    d: (__ds_scope.CONTOUR_SHAPES[shape] || __ds_scope.CONTOUR_SHAPES.box).d,
    fill: status === 'queued' ? '#AEB9C1' : '#5C7C93'
  }))), status !== 'done' ? /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      inset: 0,
      background: status === 'queued' ? 'rgba(4,9,15,.42)' : 'rgba(4,9,15,.3)'
    }
  }) : null, status === 'working' ? /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      inset: 0,
      display: 'grid',
      placeItems: 'center'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.ProgressTrace, {
    value: progress,
    size: 38
  })) : null, index != null ? /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      top: 6,
      left: 6,
      minWidth: 20,
      height: 20,
      padding: '0 5px',
      display: 'grid',
      placeItems: 'center',
      borderRadius: 'var(--r-xs)',
      background: 'var(--alpha-ink-64)',
      color: 'var(--ink-100)',
      font: 'var(--type-readout-sm)',
      letterSpacing: 'var(--tracking-readout)'
    }
  }, String(index).padStart(2, '0')) : null, (s.icon || s.text) && status !== 'working' ? /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      bottom: 6,
      right: 6,
      height: 22,
      padding: '0 6px',
      gap: 4,
      display: 'inline-flex',
      alignItems: 'center',
      borderRadius: 'var(--r-pill)',
      background: 'var(--alpha-ink-88)',
      color: s.color,
      font: 'var(--type-readout-sm)',
      letterSpacing: 'var(--tracking-readout)',
      boxShadow: status === 'done' ? 'var(--glow-accent-soft)' : 'none'
    }
  }, s.icon ? /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: s.icon,
    size: 12,
    strokeWidth: 2.4
  }) : null, s.text) : null);
}
Object.assign(__ds_scope, { BatchThumb });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/batch/BatchThumb.jsx", error: String((e && e.message) || e) }); }

// components/editor/Slider.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/* Shadow controls, feather, scale. Value always echoed in mono - sellers compare
   numbers between shots. */
function Slider({
  label,
  value = 0,
  min = 0,
  max = 100,
  step = 1,
  unit = '',
  onChange,
  style,
  ...rest
}) {
  const track = React.useRef(null);
  const [drag, setDrag] = React.useState(false);
  const pct = Math.max(0, Math.min(1, (value - min) / (max - min)));
  const set = clientX => {
    const el = track.current;
    if (!el || !onChange) return;
    const r = el.getBoundingClientRect();
    const raw = min + (clientX - r.left) / r.width * (max - min);
    const snapped = Math.round(raw / step) * step;
    onChange(Math.max(min, Math.min(max, Number(snapped.toFixed(4)))));
  };
  return /*#__PURE__*/React.createElement("div", _extends({
    style: {
      display: 'grid',
      gap: 'var(--sp-4)',
      ...style
    }
  }, rest), label || unit !== null ? /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'baseline',
      justifyContent: 'space-between',
      gap: 'var(--sp-5)'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      font: 'var(--type-caption)',
      color: 'var(--text-secondary)'
    }
  }, label), /*#__PURE__*/React.createElement("span", {
    style: {
      font: 'var(--type-readout)',
      letterSpacing: 'var(--tracking-readout)',
      color: drag ? 'var(--text-accent)' : 'var(--text-muted)'
    }
  }, value, unit)) : null, /*#__PURE__*/React.createElement("div", {
    ref: track,
    role: "slider",
    "aria-label": label,
    "aria-valuenow": value,
    "aria-valuemin": min,
    "aria-valuemax": max,
    tabIndex: 0,
    onPointerDown: e => {
      setDrag(true);
      e.currentTarget.setPointerCapture(e.pointerId);
      set(e.clientX);
    },
    onPointerMove: e => drag && set(e.clientX),
    onPointerUp: () => setDrag(false),
    onPointerCancel: () => setDrag(false),
    style: {
      position: 'relative',
      height: 'var(--touch-min)',
      display: 'flex',
      alignItems: 'center',
      cursor: 'pointer',
      touchAction: 'none'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      left: 0,
      right: 0,
      height: 6,
      borderRadius: 'var(--r-pill)',
      background: 'var(--bg-track)'
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      left: 0,
      width: pct * 100 + '%',
      height: 6,
      borderRadius: 'var(--r-pill)',
      background: 'var(--accent)'
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      left: pct * 100 + '%',
      transform: 'translateX(-50%)' + (drag ? ' scale(1.08)' : ''),
      width: 26,
      height: 26,
      borderRadius: '50%',
      background: 'var(--white)',
      boxShadow: drag ? 'var(--glow-accent)' : '0 2px 8px rgba(2,8,14,.5)',
      transition: 'box-shadow var(--dur-fast) var(--ease-out), transform var(--dur-fast) var(--ease-snap)'
    }
  })));
}
Object.assign(__ds_scope, { Slider });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/editor/Slider.jsx", error: String((e && e.message) || e) }); }

// components/feedback/EdgeNotice.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
/* The "complex edge" message. Target users are sellers, not retouchers:
   amber, never red; scissors, never a warning triangle; it offers help
   instead of reporting a failure. */
function EdgeNotice({
  title = 'Viền hơi phức tạp',
  children = 'Ảnh có phần lông/tóc hoặc vùng trong suốt. Bạn có thể dùng luôn, hoặc chỉnh viền cho gọn hơn.',
  actionLabel = 'Chỉnh viền',
  onAction,
  dismissLabel = 'Vẫn dùng',
  onDismiss,
  icon = 'scissors',
  style,
  ...rest
}) {
  return /*#__PURE__*/React.createElement("div", _extends({
    role: "status",
    style: {
      display: 'flex',
      gap: 'var(--sp-5)',
      padding: 'var(--sp-6)',
      borderRadius: 'var(--r-md)',
      background: 'var(--caution-quiet)',
      border: '1px solid rgba(255,176,32,.34)',
      animation: 'pc-fade-up var(--dur-base) var(--ease-out)',
      ...style
    }
  }, rest), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: '0 0 auto',
      width: 34,
      height: 34,
      borderRadius: 'var(--r-sm)',
      display: 'grid',
      placeItems: 'center',
      background: 'rgba(255,176,32,.18)',
      color: 'var(--amber-300)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: 18
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      minWidth: 0,
      flex: 1
    }
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      font: 'var(--type-body-strong)',
      fontSize: 'var(--fs-body-sm)',
      color: 'var(--amber-050)'
    }
  }, title), /*#__PURE__*/React.createElement("p", {
    style: {
      font: 'var(--type-caption)',
      color: 'var(--ink-200)',
      marginTop: 'var(--sp-2)',
      textWrap: 'pretty'
    }
  }, children), onAction || onDismiss ? /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 'var(--sp-5)',
      marginTop: 'var(--sp-5)'
    }
  }, onAction ? /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: onAction,
    style: {
      height: 36,
      padding: '0 var(--sp-6)',
      borderRadius: 'var(--r-pill)',
      cursor: 'pointer',
      border: '1px solid rgba(255,176,32,.5)',
      background: 'transparent',
      color: 'var(--amber-300)',
      font: 'var(--type-button)',
      fontSize: 'var(--fs-body-sm)'
    }
  }, actionLabel) : null, onDismiss ? /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: onDismiss,
    style: {
      height: 36,
      padding: '0 var(--sp-5)',
      borderRadius: 'var(--r-pill)',
      cursor: 'pointer',
      border: 'none',
      background: 'transparent',
      color: 'var(--text-secondary)',
      font: 'var(--type-button)',
      fontSize: 'var(--fs-body-sm)'
    }
  }, dismissLabel) : null) : null));
}
Object.assign(__ds_scope, { EdgeNotice });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/feedback/EdgeNotice.jsx", error: String((e && e.message) || e) }); }

// components/feedback/Toast.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
const pcToastTones = {
  neutral: 'var(--text-primary)',
  accent: 'var(--text-accent)',
  caution: 'var(--text-caution)',
  danger: 'var(--text-danger)'
};
function Toast({
  children,
  tone = 'neutral',
  icon,
  actionLabel,
  onAction,
  style,
  ...rest
}) {
  return /*#__PURE__*/React.createElement("div", _extends({
    role: "status",
    style: {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 'var(--sp-5)',
      minHeight: 46,
      padding: '0 var(--sp-4) 0 var(--sp-6)',
      borderRadius: 'var(--r-pill)',
      background: 'var(--bg-glass)',
      backdropFilter: 'var(--blur-chrome)',
      border: '1px solid var(--border-subtle)',
      boxShadow: 'var(--shadow-float)',
      color: 'var(--text-primary)',
      font: 'var(--type-caption)',
      fontSize: 'var(--fs-body-sm)',
      animation: 'pc-fade-up var(--dur-base) var(--ease-out)',
      ...style
    }
  }, rest), icon ? /*#__PURE__*/React.createElement("span", {
    style: {
      color: pcToastTones[tone]
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: icon,
    size: 18
  })) : null, /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 1
    }
  }, children), actionLabel ? /*#__PURE__*/React.createElement("button", {
    type: "button",
    onClick: onAction,
    style: {
      height: 34,
      padding: '0 var(--sp-5)',
      borderRadius: 'var(--r-pill)',
      border: 'none',
      cursor: 'pointer',
      background: 'var(--accent-quiet-strong)',
      color: 'var(--text-accent)',
      font: 'var(--type-button)',
      fontSize: 'var(--fs-body-sm)'
    }
  }, actionLabel) : null);
}
Object.assign(__ds_scope, { Toast });
})(); } catch (e) { __ds_ns.__errors.push({ path: "components/feedback/Toast.jsx", error: String((e && e.message) || e) }); }

// ui_kits/productcam-app/ExportSheet.jsx
try { (() => {
/* Screen 5. A sheet, not a page: export is the last 8 seconds of the job. */
function ExportSheet({
  count = 10,
  onClose,
  onDone
}) {
  const [fmt, setFmt] = React.useState('png');
  const [size, setSize] = React.useState(1200);
  const [saved, setSaved] = React.useState(false);
  const est = ((fmt === 'png' ? 0.34 : fmt === 'webp' ? 0.12 : 0.18) * count * (size / 1200)).toFixed(1);
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      zIndex: 20,
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'flex-end',
      background: 'var(--bg-scrim)',
      backdropFilter: 'blur(3px)'
    }
  }, saved ? /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 0,
      right: 0,
      bottom: 'calc(var(--thumb-band) + var(--sp-8))',
      display: 'grid',
      placeItems: 'center'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Toast, {
    icon: "check",
    tone: "accent",
    actionLabel: "Xem"
  }, "\u0110\xE3 l\u01B0u ", count, " \u1EA3nh v\xE0o m\xE1y")) : null, /*#__PURE__*/React.createElement(__ds_scope.Sheet, {
    title: "Xu\u1EA5t \u1EA3nh",
    subtitle: count + ' ảnh đã chọn',
    onClose: onClose,
    footer: /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(__ds_scope.Button, {
      variant: "primary",
      size: "lg",
      iconLeft: "download",
      style: {
        flex: 1
      },
      onClick: () => {
        setSaved(true);
        setTimeout(() => {
          setSaved(false);
          onDone && onDone();
        }, 1600);
      }
    }, "L\u01B0u v\xE0o m\xE1y"), /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
      icon: "share-2",
      label: "Chia s\u1EBB",
      variant: "solid",
      size: "lg"
    }))
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      font: 'var(--type-readout-sm)',
      letterSpacing: 'var(--tracking-readout)',
      textTransform: 'uppercase',
      color: 'var(--text-muted)',
      marginBottom: 'var(--sp-5)'
    }
  }, "\u0110\u1ECBnh d\u1EA1ng"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 'var(--sp-4)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Chip, {
    selected: fmt === 'png',
    onClick: () => setFmt('png')
  }, "PNG \xB7 trong su\u1ED1t"), /*#__PURE__*/React.createElement(__ds_scope.Chip, {
    selected: fmt === 'jpg',
    onClick: () => setFmt('jpg')
  }, "JPG"), /*#__PURE__*/React.createElement(__ds_scope.Chip, {
    selected: fmt === 'webp',
    onClick: () => setFmt('webp')
  }, "WEBP")), /*#__PURE__*/React.createElement("p", {
    style: {
      font: 'var(--type-readout-sm)',
      letterSpacing: 'var(--tracking-readout)',
      textTransform: 'uppercase',
      color: 'var(--text-muted)',
      margin: 'var(--sp-7) 0 var(--sp-5)'
    }
  }, "K\xEDch th\u01B0\u1EDBc"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 'var(--sp-4)'
    }
  }, [1000, 1200, 2048].map(s => /*#__PURE__*/React.createElement(__ds_scope.Chip, {
    key: s,
    selected: size === s,
    onClick: () => setSize(s)
  }, s, " px"))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--sp-4)',
      marginTop: 'var(--sp-7)',
      padding: 'var(--sp-5) var(--sp-6)',
      borderRadius: 'var(--r-md)',
      background: 'var(--bg-surface-raised)',
      boxShadow: 'var(--rim)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Badge, {
    tone: "accent",
    dot: true
  }, fmt.toUpperCase()), /*#__PURE__*/React.createElement(__ds_scope.Badge, null, size, "\xD7", size), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 1
    }
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      font: 'var(--type-readout)',
      letterSpacing: 'var(--tracking-readout)',
      color: 'var(--text-secondary)'
    }
  }, "~", est, " MB"))));
}
Object.assign(__ds_scope, { ExportSheet });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/productcam-app/ExportSheet.jsx", error: String((e && e.message) || e) }); }

// ui_kits/productcam-app/Shell.jsx
try { (() => {
/* Frame + chrome shared by every ProductCam screen. 390x844 (iPhone 14 class);
   tablet layouts keep the same bands and grow the preview area only. */
function PhoneFrame({
  children,
  dark = true,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      width: 390,
      height: 844,
      flex: '0 0 auto',
      borderRadius: 'var(--r-frame)',
      background: dark ? 'var(--bg-shell)' : 'var(--bg-light)',
      boxShadow: '0 30px 70px rgba(2,8,14,.6), inset 0 0 0 1px var(--alpha-white-08)',
      overflow: 'hidden',
      ...style
    }
  }, children);
}
function StatusBar({
  tone = 'light'
}) {
  const c = tone === 'light' ? 'var(--ink-050)' : 'var(--ink-900)';
  return /*#__PURE__*/React.createElement("div", {
    style: {
      height: 'var(--safe-top)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 var(--sp-8)',
      color: c,
      font: 'var(--type-readout)',
      letterSpacing: 'var(--tracking-readout)',
      position: 'relative',
      zIndex: 5,
      flex: '0 0 auto'
    }
  }, /*#__PURE__*/React.createElement("span", null, "9:41"), /*#__PURE__*/React.createElement("span", {
    style: {
      display: 'inline-flex',
      gap: 6,
      alignItems: 'center',
      color: c
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: "signal-high",
    size: 15
  }), /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: "wifi",
    size: 15
  }), /*#__PURE__*/React.createElement(__ds_scope.Icon, {
    name: "battery-full",
    size: 17
  })));
}
function HomeIndicator({
  tone = 'light'
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      height: 'var(--safe-bottom)',
      display: 'grid',
      placeItems: 'center',
      flex: '0 0 auto',
      position: 'relative',
      zIndex: 5
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      width: 134,
      height: 5,
      borderRadius: 'var(--r-pill)',
      background: tone === 'light' ? 'var(--alpha-white-24)' : 'var(--ink-400)'
    }
  }));
}
function ScreenHeader({
  title,
  meta,
  onBack,
  right,
  backIcon = 'chevron-left'
}) {
  return /*#__PURE__*/React.createElement("header", {
    style: {
      height: 'var(--bar-height)',
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--sp-4)',
      padding: '0 var(--sp-5)',
      flex: '0 0 auto'
    }
  }, onBack ? /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    icon: backIcon,
    label: "Quay l\u1EA1i",
    variant: "ghost",
    onClick: onBack
  }) : /*#__PURE__*/React.createElement("span", {
    style: {
      width: 8
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      minWidth: 0
    }
  }, /*#__PURE__*/React.createElement("h1", {
    style: {
      font: 'var(--type-h3)',
      color: 'var(--text-primary)'
    }
  }, title), meta ? /*#__PURE__*/React.createElement("p", {
    style: {
      font: 'var(--type-readout-sm)',
      letterSpacing: 'var(--tracking-readout)',
      textTransform: 'uppercase',
      color: 'var(--text-muted)',
      marginTop: 2
    }
  }, meta) : null), right);
}

/* Placeholder for the live camera feed / captured frame.
   Swap for real photography before any customer-facing use. */
function FeedStub({
  variant = 'table',
  children,
  style
}) {
  const scenes = {
    table: 'radial-gradient(120% 78% at 50% 14%, #79868c, #333e44 72%), linear-gradient(to bottom, #4f5d64 0 56%, #97a0a6 56%)',
    paper: 'radial-gradient(110% 70% at 50% 20%, #fdfbf6, #d8d2c6 78%), linear-gradient(to bottom,#efe9dd 0 60%,#cfc7b8 60%)',
    dark: 'radial-gradient(120% 80% at 50% 18%, #2b3238, #0b0f12 76%)'
  };
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: scenes[variant],
      ...style
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: 'radial-gradient(120% 90% at 50% 45%, rgba(0,0,0,0) 40%, rgba(4,9,15,.45))'
    }
  }), children);
}
function ThumbBand({
  children,
  scrim = true,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      minHeight: 'var(--thumb-band)',
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--sp-5)',
      padding: '0 var(--gutter-wide)',
      flex: '0 0 auto',
      background: scrim ? 'var(--scrim-bottom)' : 'transparent',
      ...style
    }
  }, children);
}
const PC_SHOTS = [{
  id: 1,
  status: 'done',
  shape: 'bottle'
}, {
  id: 2,
  status: 'done',
  shape: 'box'
}, {
  id: 3,
  status: 'review',
  shape: 'shoe'
}, {
  id: 4,
  status: 'done',
  shape: 'bag'
}, {
  id: 5,
  status: 'working',
  shape: 'bottle',
  progress: 64
}, {
  id: 6,
  status: 'working',
  shape: 'box',
  progress: 28
}, {
  id: 7,
  status: 'queued',
  shape: 'bag'
}, {
  id: 8,
  status: 'queued',
  shape: 'shoe'
}, {
  id: 9,
  status: 'done',
  shape: 'box'
}, {
  id: 10,
  status: 'error',
  shape: 'bottle'
}, {
  id: 11,
  status: 'done',
  shape: 'bag'
}, {
  id: 12,
  status: 'done',
  shape: 'shoe'
}];
Object.assign(__ds_scope, { PhoneFrame, StatusBar, HomeIndicator, ScreenHeader, FeedStub, ThumbBand, PC_SHOTS });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/productcam-app/Shell.jsx", error: String((e && e.message) || e) }); }

// ui_kits/productcam-app/BackgroundEditor.jsx
try { (() => {
/* Screen 3. The preview is the largest thing on screen and updates on every
   touch - the same "see it before you commit" promise as the viewfinder. */
function BackgroundEditor({
  shape = 'bottle',
  onBack,
  onExport
}) {
  const [bg, setBg] = React.useState('white');
  const [preset, setPreset] = React.useState('nhe');
  const [strength, setStrength] = React.useState(34);
  const [blur, setBlur] = React.useState(14);
  const opt = __ds_scope.PC_BACKGROUNDS.find(o => o.id === bg) || __ds_scope.PC_BACKGROUNDS[0];
  const shadow = preset === 'khong' ? 'none' : 'drop-shadow(0 ' + Math.round(blur * .6) + 'px ' + blur + 'px rgba(4,9,15,' + strength / 100 + '))';
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      display: 'flex',
      flexDirection: 'column',
      background: 'var(--bg-app)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.StatusBar, null), /*#__PURE__*/React.createElement(__ds_scope.ScreenHeader, {
    title: "N\u1EC1n & b\xF3ng",
    meta: "xem tr\u1EF1c ti\u1EBFp",
    onBack: onBack,
    right: /*#__PURE__*/React.createElement(__ds_scope.Readout, {
      state: "locked",
      meta: opt.label
    }, "N\u1EC1n")
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '0 var(--gutter)',
      flex: '1 1 auto',
      minHeight: 0,
      display: 'flex'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: '100%',
      borderRadius: 'var(--r-lg)',
      overflow: 'hidden',
      display: 'grid',
      placeItems: 'center',
      boxShadow: 'var(--rim)',
      background: opt.type === 'checker' ? 'var(--checker-light)' : opt.value
    }
  }, /*#__PURE__*/React.createElement("svg", {
    viewBox: "0 0 100 100",
    width: "76%",
    height: "76%",
    preserveAspectRatio: "xMidYMid meet",
    style: {
      filter: shadow
    }
  }, /*#__PURE__*/React.createElement("path", {
    d: (__ds_scope.CONTOUR_SHAPES[shape] || __ds_scope.CONTOUR_SHAPES.box).d,
    fill: "#5C7C93"
  })))), /*#__PURE__*/React.createElement(__ds_scope.Sheet, {
    handle: false,
    tone: "accent",
    style: {
      paddingBottom: 'var(--sp-6)'
    },
    footer: /*#__PURE__*/React.createElement(__ds_scope.Button, {
      variant: "primary",
      size: "lg",
      fullWidth: true,
      iconLeft: "download",
      onClick: onExport
    }, "Xu\u1EA5t \u1EA3nh")
  }, /*#__PURE__*/React.createElement("p", {
    style: {
      font: 'var(--type-readout-sm)',
      letterSpacing: 'var(--tracking-readout)',
      textTransform: 'uppercase',
      color: 'var(--text-muted)',
      marginBottom: 'var(--sp-5)'
    }
  }, "N\u1EC1n"), /*#__PURE__*/React.createElement(__ds_scope.BackgroundSwatchPicker, {
    value: bg,
    onChange: setBg
  }), /*#__PURE__*/React.createElement("p", {
    style: {
      font: 'var(--type-readout-sm)',
      letterSpacing: 'var(--tracking-readout)',
      textTransform: 'uppercase',
      color: 'var(--text-muted)',
      margin: 'var(--sp-7) 0 var(--sp-5)'
    }
  }, "B\xF3ng \u0111\u1ED5"), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 'var(--sp-4)'
    }
  }, [['khong', 'Không'], ['nhe', 'Nhẹ'], ['vua', 'Vừa'], ['dam', 'Đậm']].map(([id, label]) => /*#__PURE__*/React.createElement(__ds_scope.Chip, {
    key: id,
    size: "sm",
    selected: preset === id,
    onClick: () => {
      setPreset(id);
      if (id === 'nhe') {
        setStrength(30);
        setBlur(12);
      }
      if (id === 'vua') {
        setStrength(48);
        setBlur(20);
      }
      if (id === 'dam') {
        setStrength(66);
        setBlur(28);
      }
    }
  }, label))), preset !== 'khong' ? /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 'var(--sp-5)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Slider, {
    label: "\u0110\u1ED9 \u0111\u1EADm",
    value: strength,
    onChange: setStrength,
    unit: "%"
  }), /*#__PURE__*/React.createElement(__ds_scope.Slider, {
    label: "\u0110\u1ED9 m\u1EC1m",
    value: blur,
    onChange: setBlur,
    unit: "px",
    max: 40
  })) : null), /*#__PURE__*/React.createElement(__ds_scope.HomeIndicator, null));
}
Object.assign(__ds_scope, { BackgroundEditor });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/productcam-app/BackgroundEditor.jsx", error: String((e && e.message) || e) }); }

// ui_kits/productcam-app/BatchSession.jsx
try { (() => {
/* Screen 4. Processing runs in the background; the grid is the status board.
   Nothing blocks the user from shooting more. */
function BatchSession({
  shots = __ds_scope.PC_SHOTS,
  onBack,
  onExport,
  onMore,
  onOpen
}) {
  const [filter, setFilter] = React.useState('all');
  const [sel, setSel] = React.useState(null);
  const counts = shots.reduce((a, s) => ({
    ...a,
    [s.status]: (a[s.status] || 0) + 1
  }), {});
  const list = filter === 'all' ? shots : shots.filter(s => s.status === filter);
  const working = (counts.working || 0) + (counts.queued || 0);
  const readyCount = counts.done || 0;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      display: 'flex',
      flexDirection: 'column',
      background: 'var(--bg-app)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.StatusBar, null), /*#__PURE__*/React.createElement(__ds_scope.ScreenHeader, {
    title: "Phi\xEAn ch\u1EE5p",
    meta: shots.length + ' ảnh · 14:32',
    onBack: onBack,
    right: /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
      icon: "more-horizontal",
      label: "Th\xEAm",
      variant: "ghost"
    })
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '0 var(--gutter)',
      display: 'flex',
      alignItems: 'center',
      flexWrap: 'wrap',
      gap: 'var(--sp-4)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Readout, {
    state: working ? 'scanning' : 'locked',
    meta: readyCount + '/' + shots.length
  }, working ? 'Đang xử lý ' + working + ' ảnh' : 'Đã xong tất cả'), counts.review ? /*#__PURE__*/React.createElement(__ds_scope.Badge, {
    tone: "caution",
    dot: true
  }, counts.review, " XEM L\u1EA0I") : null, counts.error ? /*#__PURE__*/React.createElement(__ds_scope.Badge, {
    tone: "danger",
    dot: true
  }, counts.error, " L\u1ED6I") : null), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 'var(--sp-4)',
      padding: 'var(--sp-6) var(--gutter) var(--sp-5)',
      overflowX: 'auto'
    }
  }, [['all', 'Tất cả'], ['done', 'Xong'], ['review', 'Cần xem lại'], ['error', 'Lỗi']].map(([id, label]) => /*#__PURE__*/React.createElement(__ds_scope.Chip, {
    key: id,
    size: "sm",
    selected: filter === id,
    tone: id === 'review' ? 'caution' : 'default',
    onClick: () => setFilter(id)
  }, label))), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      overflowY: 'auto',
      padding: '0 var(--gutter)',
      scrollbarWidth: 'none'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: 'repeat(3, 1fr)',
      gap: 'var(--grid-gap)'
    }
  }, list.map((s, i) => /*#__PURE__*/React.createElement(__ds_scope.BatchThumb, {
    key: s.id,
    index: s.id,
    status: s.status,
    progress: s.progress,
    shape: s.shape,
    selected: sel === s.id,
    onClick: () => {
      setSel(s.id);
      onOpen && onOpen(s);
    }
  })))), /*#__PURE__*/React.createElement(__ds_scope.ThumbBand, {
    scrim: false,
    style: {
      gap: 'var(--sp-5)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Button, {
    variant: "secondary",
    size: "lg",
    iconLeft: "camera",
    onClick: onMore,
    style: {
      flex: '0 0 122px'
    }
  }, "Ch\u1EE5p th\xEAm"), /*#__PURE__*/React.createElement(__ds_scope.Button, {
    variant: "primary",
    size: "lg",
    iconLeft: "download",
    onClick: onExport,
    style: {
      flex: '1 1 0',
      minWidth: 0
    }
  }, "Xu\u1EA5t ", readyCount, " \u1EA3nh")), /*#__PURE__*/React.createElement(__ds_scope.HomeIndicator, null));
}
Object.assign(__ds_scope, { BatchSession });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/productcam-app/BatchSession.jsx", error: String((e && e.message) || e) }); }

// ui_kits/productcam-app/CameraCapture.jsx
try { (() => {
/* Screen 1, the one that matters most. Everything above the thumb band is the
   subject; everything the user touches sits in the bottom 132px. */
function CameraCapture({
  onOpenSession,
  onCapture,
  mode = 'batch',
  onMode,
  shots = [],
  shape = 'bottle'
}) {
  const [locked, setLocked] = React.useState(false);
  const [flash, setFlash] = React.useState('off');
  const [grid, setGrid] = React.useState(true);
  const [busy, setBusy] = React.useState(false);
  React.useEffect(() => {
    setLocked(false);
    const t = setTimeout(() => setLocked(true), 1600);
    return () => clearTimeout(t);
  }, [shape]);
  const fire = () => {
    setBusy(true);
    setTimeout(() => {
      setBusy(false);
      onCapture && onCapture();
    }, 420);
  };
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      display: 'flex',
      flexDirection: 'column',
      background: 'var(--bg-shell)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.FeedStub, {
    variant: "table"
  }, grid ? /*#__PURE__*/React.createElement("svg", {
    width: "100%",
    height: "100%",
    style: {
      position: 'absolute',
      inset: 0,
      opacity: .18
    }
  }, /*#__PURE__*/React.createElement("line", {
    x1: "33.33%",
    y1: "0",
    x2: "33.33%",
    y2: "100%",
    stroke: "#fff",
    strokeWidth: "1"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "66.66%",
    y1: "0",
    x2: "66.66%",
    y2: "100%",
    stroke: "#fff",
    strokeWidth: "1"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "0",
    y1: "33.33%",
    x2: "100%",
    y2: "33.33%",
    stroke: "#fff",
    strokeWidth: "1"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "0",
    y1: "66.66%",
    x2: "100%",
    y2: "66.66%",
    stroke: "#fff",
    strokeWidth: "1"
  })) : null, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 0,
      right: 0,
      top: 150,
      bottom: 210
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.ContourOverlay, {
    state: locked ? 'locked' : 'scanning',
    shape: shape
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: 'var(--scrim-top)',
      height: 150
    }
  })), /*#__PURE__*/React.createElement(__ds_scope.StatusBar, null), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      zIndex: 3,
      display: 'flex',
      alignItems: 'center',
      gap: 'var(--sp-4)',
      padding: '0 var(--gutter)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    icon: flash === 'off' ? 'zap-off' : 'zap',
    label: "\u0110\xE8n flash",
    active: flash === 'on',
    onClick: () => setFlash(flash === 'off' ? 'on' : 'off')
  }), /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    icon: "grid-3x3",
    label: "L\u01B0\u1EDBi",
    active: grid,
    onClick: () => setGrid(!grid)
  }), /*#__PURE__*/React.createElement("span", {
    style: {
      flex: 1
    }
  }), /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    icon: "refresh-cw",
    label: "\u0110\u1ED5i camera"
  }), /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    icon: "settings-2",
    label: "C\xE0i \u0111\u1EB7t"
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      zIndex: 3,
      display: 'grid',
      placeItems: 'center',
      paddingTop: 'var(--sp-6)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Readout, {
    state: locked ? 'locked' : 'scanning',
    meta: locked ? '1200×1200' : null
  }, locked ? 'Đã khoá viền' : 'Đang tìm vật thể')), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1
    }
  }), mode === 'batch' && shots.length ? /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      zIndex: 3,
      display: 'flex',
      gap: 'var(--sp-4)',
      padding: '0 var(--gutter) var(--sp-5)',
      overflowX: 'auto'
    }
  }, shots.slice(-6).map((s, i) => /*#__PURE__*/React.createElement(__ds_scope.CheckerSurface, {
    key: s.id,
    radius: "var(--r-sm)",
    style: {
      width: 54,
      height: 54,
      flex: '0 0 auto',
      outline: i === shots.length - 1 ? '2px solid var(--contour-core)' : 'none'
    }
  }, /*#__PURE__*/React.createElement("svg", {
    viewBox: "0 0 100 100",
    width: "80%",
    height: "80%"
  }, /*#__PURE__*/React.createElement("path", {
    d: (__ds_scope.CONTOUR_SHAPES[s.shape] || __ds_scope.CONTOUR_SHAPES.box).d,
    fill: "#5C7C93"
  }))))) : null, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      zIndex: 3,
      display: 'grid',
      placeItems: 'center',
      paddingBottom: 'var(--sp-5)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.ModeToggle, {
    value: mode,
    onChange: onMode
  })), /*#__PURE__*/React.createElement(__ds_scope.ThumbBand, {
    style: {
      zIndex: 3
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 56
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      display: 'grid',
      placeItems: 'center'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.ShutterButton, {
    state: busy ? 'busy' : locked ? 'locked' : 'ready',
    count: mode === 'batch' ? shots.length : undefined,
    onCapture: fire
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      width: 56,
      display: 'flex',
      justifyContent: 'flex-end'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
    icon: "images",
    label: "Phi\xEAn ch\u1EE5p",
    badge: shots.length || undefined,
    onClick: onOpenSession,
    size: "lg"
  }))), /*#__PURE__*/React.createElement(__ds_scope.HomeIndicator, null));
}
Object.assign(__ds_scope, { CameraCapture });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/productcam-app/CameraCapture.jsx", error: String((e && e.message) || e) }); }

// ui_kits/productcam-app/History.jsx
try { (() => {
/* Screen 6. Ảnh đã xử lý, newest first, grouped by day. Same thumbnail component
   as the batch grid so a cutout always looks like a cutout. */
const PC_HISTORY = [{
  day: 'Hôm nay · 14:32',
  items: [['bottle', 'done'], ['box', 'done'], ['shoe', 'review'], ['bag', 'done'], ['box', 'done'], ['bottle', 'done']]
}, {
  day: '09/08 · 20:11',
  items: [['bag', 'done'], ['shoe', 'done'], ['box', 'done']]
}];
function History({
  onBack,
  onCamera,
  onOpen
}) {
  const [filter, setFilter] = React.useState('all');
  let n = 0;
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      display: 'flex',
      flexDirection: 'column',
      background: 'var(--bg-app)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.StatusBar, null), /*#__PURE__*/React.createElement(__ds_scope.ScreenHeader, {
    title: "\u1EA2nh \u0111\xE3 x\u1EED l\xFD",
    meta: "42 \u1EA3nh \xB7 6 phi\xEAn",
    onBack: onBack,
    right: /*#__PURE__*/React.createElement(__ds_scope.IconButton, {
      icon: "search",
      label: "T\xECm",
      variant: "ghost"
    })
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 'var(--sp-4)',
      padding: '0 var(--gutter) var(--sp-6)',
      overflowX: 'auto'
    }
  }, [['all', 'Tất cả'], ['today', 'Hôm nay'], ['review', 'Cần xem lại'], ['png', 'PNG']].map(([id, label]) => /*#__PURE__*/React.createElement(__ds_scope.Chip, {
    key: id,
    size: "sm",
    selected: filter === id,
    tone: id === 'review' ? 'caution' : 'default',
    onClick: () => setFilter(id)
  }, label))), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      overflowY: 'auto',
      padding: '0 var(--gutter)',
      scrollbarWidth: 'none'
    }
  }, PC_HISTORY.map(g => /*#__PURE__*/React.createElement("section", {
    key: g.day,
    style: {
      marginBottom: 'var(--sp-8)'
    }
  }, /*#__PURE__*/React.createElement("h2", {
    style: {
      font: 'var(--type-readout-sm)',
      letterSpacing: 'var(--tracking-readout)',
      textTransform: 'uppercase',
      color: 'var(--text-muted)',
      marginBottom: 'var(--sp-5)'
    }
  }, g.day), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'grid',
      gridTemplateColumns: 'repeat(3, 1fr)',
      gap: 'var(--grid-gap)'
    }
  }, g.items.map(([shape, status], i) => {
    n += 1;
    return /*#__PURE__*/React.createElement(__ds_scope.BatchThumb, {
      key: g.day + i,
      index: n,
      status: status,
      shape: shape,
      onClick: () => onOpen && onOpen(shape)
    });
  }))))), /*#__PURE__*/React.createElement(__ds_scope.ThumbBand, {
    scrim: false
  }, /*#__PURE__*/React.createElement(__ds_scope.Button, {
    variant: "primary",
    size: "lg",
    fullWidth: true,
    iconLeft: "camera",
    onClick: onCamera
  }, "M\u1EDF camera")), /*#__PURE__*/React.createElement(__ds_scope.HomeIndicator, null));
}
Object.assign(__ds_scope, { History });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/productcam-app/History.jsx", error: String((e && e.message) || e) }); }

// ui_kits/productcam-app/ProcessingReview.jsx
try { (() => {
/* Screen 2. The checkerboard does the explaining: background is gone.
   The contour reappears over the result - the promise from the viewfinder, kept. */
function ProcessingReview({
  shape = 'shoe',
  complex = true,
  onRetake,
  onAccept
}) {
  const [phase, setPhase] = React.useState('working');
  React.useEffect(() => {
    setPhase('working');
    const t = setTimeout(() => setPhase('ready'), 1100);
    return () => clearTimeout(t);
  }, [shape]);
  const done = phase === 'ready';
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      display: 'flex',
      flexDirection: 'column',
      background: 'var(--bg-app)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.StatusBar, null), /*#__PURE__*/React.createElement(__ds_scope.ScreenHeader, {
    title: "K\u1EBFt qu\u1EA3",
    meta: done ? 'đã tách nền · 0.8s' : 'đang tách nền',
    onBack: onRetake,
    backIcon: "x",
    right: /*#__PURE__*/React.createElement(__ds_scope.Badge, {
      tone: done ? 'accent' : 'neutral',
      dot: true
    }, done ? 'XONG' : 'ĐANG XỬ LÝ')
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '0 var(--gutter)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.CheckerSurface, {
    style: {
      width: '100%',
      aspectRatio: '1 / 1.06',
      borderRadius: 'var(--r-lg)'
    }
  }, /*#__PURE__*/React.createElement("svg", {
    viewBox: "0 0 100 100",
    width: "88%",
    height: "88%",
    preserveAspectRatio: "xMidYMid meet"
  }, /*#__PURE__*/React.createElement("path", {
    d: (__ds_scope.CONTOUR_SHAPES[shape] || __ds_scope.CONTOUR_SHAPES.box).d,
    fill: "#5C7C93",
    opacity: done ? 1 : .35
  })), done ? /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: '6%'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.ContourOverlay, {
    state: complex ? 'review' : 'locked',
    shape: shape,
    ticks: false,
    sweep: false
  })) : /*#__PURE__*/React.createElement("span", {
    style: {
      position: 'absolute',
      display: 'grid',
      placeItems: 'center'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.ProgressTrace, {
    indeterminate: true,
    size: 52,
    label: false
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 'var(--sp-4)',
      marginTop: 'var(--sp-5)',
      alignItems: 'center'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Readout, {
    state: done ? complex ? 'review' : 'locked' : 'scanning',
    meta: "PNG"
  }, done ? complex ? 'Viền phức tạp' : 'Viền sạch' : 'Đang tách nền'), /*#__PURE__*/React.createElement(__ds_scope.Badge, null, "1200\xD71200"), /*#__PURE__*/React.createElement(__ds_scope.Badge, null, "340 KB")), done && complex ? /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 'var(--sp-6)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.EdgeNotice, {
    onAction: () => {},
    onDismiss: () => {}
  })) : null), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1
    }
  }), /*#__PURE__*/React.createElement(__ds_scope.ThumbBand, {
    scrim: false,
    style: {
      gap: 'var(--sp-5)'
    }
  }, /*#__PURE__*/React.createElement(__ds_scope.Button, {
    variant: "secondary",
    size: "lg",
    iconLeft: "rotate-ccw",
    onClick: onRetake,
    style: {
      flex: '0 0 132px'
    }
  }, "Ch\u1EE5p l\u1EA1i"), /*#__PURE__*/React.createElement(__ds_scope.Button, {
    variant: "primary",
    size: "lg",
    iconLeft: "check",
    onClick: onAccept,
    disabled: !done,
    style: {
      flex: 1
    }
  }, "Ch\u1EA5p nh\u1EADn")), /*#__PURE__*/React.createElement(__ds_scope.HomeIndicator, null));
}
Object.assign(__ds_scope, { ProcessingReview });
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/productcam-app/ProcessingReview.jsx", error: String((e && e.message) || e) }); }

__ds_ns.BatchThumb = __ds_scope.BatchThumb;

__ds_ns.ProgressTrace = __ds_scope.ProgressTrace;

__ds_ns.CONTOUR_SHAPES = __ds_scope.CONTOUR_SHAPES;

__ds_ns.ContourOverlay = __ds_scope.ContourOverlay;

__ds_ns.ModeToggle = __ds_scope.ModeToggle;

__ds_ns.Readout = __ds_scope.Readout;

__ds_ns.ShutterButton = __ds_scope.ShutterButton;

__ds_ns.Badge = __ds_scope.Badge;

__ds_ns.Button = __ds_scope.Button;

__ds_ns.Chip = __ds_scope.Chip;

__ds_ns.Icon = __ds_scope.Icon;

__ds_ns.IconButton = __ds_scope.IconButton;

__ds_ns.Sheet = __ds_scope.Sheet;

__ds_ns.PC_BACKGROUNDS = __ds_scope.PC_BACKGROUNDS;

__ds_ns.BackgroundSwatchPicker = __ds_scope.BackgroundSwatchPicker;

__ds_ns.CheckerSurface = __ds_scope.CheckerSurface;

__ds_ns.Slider = __ds_scope.Slider;

__ds_ns.EdgeNotice = __ds_scope.EdgeNotice;

__ds_ns.Toast = __ds_scope.Toast;

__ds_ns.BackgroundEditor = __ds_scope.BackgroundEditor;

__ds_ns.BatchSession = __ds_scope.BatchSession;

__ds_ns.CameraCapture = __ds_scope.CameraCapture;

__ds_ns.ExportSheet = __ds_scope.ExportSheet;

__ds_ns.History = __ds_scope.History;

__ds_ns.ProcessingReview = __ds_scope.ProcessingReview;

__ds_ns.PhoneFrame = __ds_scope.PhoneFrame;

__ds_ns.StatusBar = __ds_scope.StatusBar;

__ds_ns.HomeIndicator = __ds_scope.HomeIndicator;

__ds_ns.ScreenHeader = __ds_scope.ScreenHeader;

__ds_ns.FeedStub = __ds_scope.FeedStub;

__ds_ns.ThumbBand = __ds_scope.ThumbBand;

__ds_ns.PC_SHOTS = __ds_scope.PC_SHOTS;

})();
