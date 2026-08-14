/* ProductCam — màn hình bổ sung cho UI kit của design system.
   Camera (bản có wire nút Cài đặt), Lịch sử (có thao tác từng ảnh), Cài đặt. */
const PC = window.ProductCamDesignSystem_8d7e15;
const { Icon, Button, IconButton, Chip, Badge, Sheet, Toast, Readout, ContourOverlay, ShutterButton, ModeToggle, Slider,
  CheckerSurface, BatchThumb, CONTOUR_SHAPES, StatusBar, HomeIndicator, ScreenHeader, FeedStub, ThumbBand, EdgeNotice, ProgressTrace } = PC;

const screenBase = { position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', background: 'var(--bg-app)' };
const groupLabel = { font: 'var(--type-readout-sm)', letterSpacing: 'var(--tracking-readout)', textTransform: 'uppercase', color: 'var(--text-muted)', margin: '0 0 var(--sp-5)' };
const metaMono = { font: 'var(--type-readout)', letterSpacing: 'var(--tracking-readout)', textTransform: 'uppercase', color: 'var(--text-secondary)' };

/* ---------- 1 · Camera ---------- */
function CameraScreen({ mode = 'batch', onMode, shots = [], shape = 'bottle', onCapture, onOpenSession, onSettings }) {
  const [locked, setLocked] = React.useState(false);
  const [flash, setFlash] = React.useState('off');
  const [grid, setGrid] = React.useState(true);
  const [facing, setFacing] = React.useState('back');
  const [busy, setBusy] = React.useState(false);
  React.useEffect(() => { setLocked(false); const t = setTimeout(() => setLocked(true), 1600); return () => clearTimeout(t); }, [shape, facing]);
  const fire = () => { setBusy(true); setTimeout(() => { setBusy(false); onCapture && onCapture(); }, 420); };
  return (
    <div style={{ ...screenBase, background: 'var(--bg-shell)' }}>
      <FeedStub variant={facing === 'back' ? 'table' : 'paper'}>
        {grid ? (
          <svg width="100%" height="100%" style={{ position: 'absolute', inset: 0, opacity: .18 }}>
            <line x1="33.33%" y1="0" x2="33.33%" y2="100%" stroke="#fff" strokeWidth="1" />
            <line x1="66.66%" y1="0" x2="66.66%" y2="100%" stroke="#fff" strokeWidth="1" />
            <line x1="0" y1="33.33%" x2="100%" y2="33.33%" stroke="#fff" strokeWidth="1" />
            <line x1="0" y1="66.66%" x2="100%" y2="66.66%" stroke="#fff" strokeWidth="1" />
          </svg>
        ) : null}
        <div style={{ position: 'absolute', left: 0, right: 0, top: 150, bottom: 210 }}>
          <ContourOverlay state={locked ? 'locked' : 'scanning'} shape={shape} />
        </div>
        <div style={{ position: 'absolute', inset: 0, background: 'var(--scrim-top)', height: 150 }} />
      </FeedStub>
      <StatusBar />
      <div style={{ position: 'relative', zIndex: 3, display: 'flex', alignItems: 'center', gap: 'var(--sp-4)', padding: '0 var(--gutter)' }}>
        <IconButton icon={flash === 'off' ? 'zap-off' : 'zap'} label="Đèn flash" active={flash === 'on'} onClick={() => setFlash(flash === 'off' ? 'on' : 'off')} />
        <IconButton icon="grid-3x3" label="Lưới" active={grid} onClick={() => setGrid(!grid)} />
        <span style={{ flex: 1 }} />
        <IconButton icon="refresh-cw" label="Đổi camera" active={facing === 'front'} onClick={() => setFacing(facing === 'back' ? 'front' : 'back')} />
        <IconButton icon="settings-2" label="Cài đặt" onClick={onSettings} />
      </div>
      <div style={{ position: 'relative', zIndex: 3, display: 'grid', placeItems: 'center', paddingTop: 'var(--sp-6)' }}>
        <Readout state={locked ? 'locked' : 'scanning'} meta={locked ? '1200×1200' : null}>{locked ? 'Đã khoá viền' : 'Đang tìm vật thể'}</Readout>
      </div>
      <div style={{ flex: 1 }} />
      {mode === 'batch' && shots.length ? (
        <div style={{ position: 'relative', zIndex: 3, display: 'flex', gap: 'var(--sp-4)', padding: '0 var(--gutter) var(--sp-5)', overflowX: 'auto', scrollbarWidth: 'none' }}>
          {shots.slice(-6).map((s, i) => (
            <CheckerSurface key={s.id} radius="var(--r-sm)" style={{ width: 54, height: 54, flex: '0 0 auto', outline: i === Math.min(shots.length, 6) - 1 ? '2px solid var(--contour-core)' : 'none' }}>
              <svg viewBox="0 0 100 100" width="80%" height="80%"><path d={(CONTOUR_SHAPES[s.shape] || CONTOUR_SHAPES.box).d} fill="#5C7C93" /></svg>
            </CheckerSurface>
          ))}
        </div>
      ) : null}
      <div style={{ position: 'relative', zIndex: 3, display: 'grid', placeItems: 'center', paddingBottom: 'var(--sp-5)' }}>
        <ModeToggle value={mode} onChange={onMode} />
      </div>
      <ThumbBand style={{ zIndex: 3 }}>
        <div style={{ width: 56 }} />
        <div style={{ flex: 1, display: 'grid', placeItems: 'center' }}>
          <ShutterButton state={busy ? 'busy' : locked ? 'locked' : 'ready'} count={mode === 'batch' ? shots.length : undefined} onCapture={fire} />
        </div>
        <div style={{ width: 56, display: 'flex', justifyContent: 'flex-end' }}>
          <IconButton icon="images" label="Phiên chụp" badge={shots.length || undefined} onClick={onOpenSession} size="lg" />
        </div>
      </ThumbBand>
      <HomeIndicator />
    </div>
  );
}

/* ---------- 2 · Kết quả + chỉnh viền ---------- */
function EdgeRefineSheet({ shape, spread, soft, onSpread, onSoft, onClose, onDone }) {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 20, display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', background: 'var(--bg-scrim)', backdropFilter: 'blur(3px)' }}>
      <Sheet title="Chỉnh viền" subtitle="Thu gọn hoặc làm mềm mép cắt" tone="accent" onClose={onClose}
        footer={<Button variant="primary" size="lg" fullWidth iconLeft="check" onClick={onDone}>Xong</Button>}>
        <div style={{ display: 'grid', placeItems: 'center', marginBottom: 'var(--sp-6)' }}>
          <CheckerSurface style={{ width: 168, height: 168, borderRadius: 'var(--r-md)' }}>
            <svg viewBox="0 0 100 100" width="84%" height="84%" style={{ filter: 'blur(' + (soft * .06) + 'px)' }}>
              <path d={(CONTOUR_SHAPES[shape] || CONTOUR_SHAPES.box).d} fill="#5C7C93" stroke="#5C7C93" strokeWidth={Math.max(0, spread) * .18} strokeOpacity={spread < 0 ? 0 : 1} transform={spread < 0 ? 'translate(50 50) scale(' + (1 + spread / 260) + ') translate(-50 -50)' : undefined} />
            </svg>
          </CheckerSurface>
        </div>
        <Slider label="Thu / giãn viền" value={spread} min={-10} max={10} onChange={onSpread} unit="px" />
        <Slider label="Làm mềm mép" value={soft} min={0} max={10} onChange={onSoft} unit="px" />
        <p style={{ font: 'var(--type-caption)', color: 'var(--text-muted)', marginTop: 'var(--sp-5)', textWrap: 'pretty' }}>Chỉnh viền chỉ đổi mép cắt, không đổi độ phân giải ảnh xuất.</p>
      </Sheet>
    </div>
  );
}

function ReviewScreen({ shape = 'shoe', complex = true, onRetake, onAccept }) {
  const [phase, setPhase] = React.useState('working');
  const [notice, setNotice] = React.useState(true);
  const [refine, setRefine] = React.useState(false);
  const [edited, setEdited] = React.useState(false);
  const [spread, setSpread] = React.useState(0);
  const [soft, setSoft] = React.useState(2);
  React.useEffect(() => {
    setPhase('working'); setNotice(true); setEdited(false); setSpread(0); setSoft(2);
    const t = setTimeout(() => setPhase('ready'), 1100);
    return () => clearTimeout(t);
  }, [shape]);
  const done = phase === 'ready';
  const state = !done ? 'scanning' : (complex && !edited) ? 'review' : 'locked';
  return (
    <div style={screenBase}>
      <StatusBar />
      <ScreenHeader title="Kết quả" meta={done ? 'đã tách nền · 0.8s' : 'đang tách nền'} onBack={onRetake} backIcon="x"
        right={<Badge tone={done ? 'accent' : 'neutral'} dot>{done ? 'XONG' : 'ĐANG XỬ LÝ'}</Badge>} />
      <div style={{ padding: '0 var(--gutter)' }}>
        <CheckerSurface style={{ width: '100%', aspectRatio: '1 / 1.06', borderRadius: 'var(--r-lg)' }}>
          <svg viewBox="0 0 100 100" width="88%" height="88%" preserveAspectRatio="xMidYMid meet" style={{ filter: 'blur(' + (edited ? soft * .04 : 0) + 'px)' }}>
            <path d={(CONTOUR_SHAPES[shape] || CONTOUR_SHAPES.box).d} fill="#5C7C93" opacity={done ? 1 : .35} />
          </svg>
          {done ? (
            <div style={{ position: 'absolute', inset: '6%' }}>
              <ContourOverlay state={state} shape={shape} ticks={false} sweep={false} />
            </div>
          ) : (
            <span style={{ position: 'absolute', display: 'grid', placeItems: 'center' }}><ProgressTrace indeterminate size={52} label={false} /></span>
          )}
        </CheckerSurface>
        <div style={{ display: 'flex', gap: 'var(--sp-4)', marginTop: 'var(--sp-5)', alignItems: 'center' }}>
          <Readout state={state} meta="PNG">
            {!done ? 'Đang tách nền' : (complex && !edited) ? 'Viền phức tạp' : edited ? 'Đã chỉnh viền' : 'Viền sạch'}
          </Readout>
          <Badge>1200×1200</Badge>
          <Badge>340 KB</Badge>
        </div>
        {done && complex && notice && !edited ? (
          <div style={{ marginTop: 'var(--sp-6)' }}>
            <EdgeNotice onAction={() => setRefine(true)} onDismiss={() => setNotice(false)} />
          </div>
        ) : null}
        {done && (edited || (complex && !notice)) ? (
          <div style={{ marginTop: 'var(--sp-6)', display: 'flex', justifyContent: 'flex-start' }}>
            <Button variant="secondary" size="sm" iconLeft="scissors" onClick={() => setRefine(true)}>Chỉnh viền</Button>
          </div>
        ) : null}
      </div>
      <div style={{ flex: 1 }} />
      <ThumbBand scrim={false} style={{ gap: 'var(--sp-5)' }}>
        <Button variant="secondary" size="lg" iconLeft="rotate-ccw" onClick={onRetake} style={{ flex: '0 0 132px' }}>Chụp lại</Button>
        <Button variant="primary" size="lg" iconLeft="check" onClick={onAccept} disabled={!done} style={{ flex: 1 }}>Chấp nhận</Button>
      </ThumbBand>
      <HomeIndicator />
      {refine ? <EdgeRefineSheet shape={shape} spread={spread} soft={soft} onSpread={setSpread} onSoft={setSoft}
        onClose={() => setRefine(false)} onDone={() => { setRefine(false); setEdited(true); }} /> : null}
    </div>
  );
}

/* ---------- 6 · Lịch sử ---------- */
const PC_HISTORY_SEED = [
  { day: 'Hôm nay · 14:32', items: [{ id: 'h1', shape: 'bottle', status: 'done' }, { id: 'h2', shape: 'box', status: 'done' }, { id: 'h3', shape: 'shoe', status: 'review' }, { id: 'h4', shape: 'bag', status: 'done' }, { id: 'h5', shape: 'box', status: 'done' }, { id: 'h6', shape: 'bottle', status: 'done' }] },
  { day: '09/08 · 20:11', items: [{ id: 'h7', shape: 'bag', status: 'done' }, { id: 'h8', shape: 'shoe', status: 'done' }, { id: 'h9', shape: 'box', status: 'done' }] },
];

function ItemSheet({ item, onClose, onEdit, onExport, onDelete }) {
  const rows = [
    ['image', 'Chỉnh nền lại', 'Mở lại trong màn hình nền & bóng', onEdit],
    ['download', 'Xuất lại', 'PNG trong suốt · 1200×1200', onExport],
    ['share-2', 'Chia sẻ', 'Gửi qua ứng dụng khác', onClose],
  ];
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 20, display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', background: 'var(--bg-scrim)', backdropFilter: 'blur(3px)' }} onClick={onClose}>
      <div onClick={(e) => e.stopPropagation()}>
        <Sheet title={'Ảnh ' + String(item.n).padStart(2, '0')} subtitle="PNG · 1200×1200 · 340 KB" onClose={onClose}
          footer={<Button variant="danger" size="lg" fullWidth iconLeft="x" onClick={onDelete}>Xoá ảnh</Button>}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 'var(--sp-4)' }}>
            {rows.map(([icon, title, desc, act]) => (
              <button key={title} type="button" onClick={act} style={{
                display: 'flex', alignItems: 'center', gap: 'var(--sp-5)', minHeight: 'var(--touch-comfortable)', width: '100%', textAlign: 'left',
                padding: 'var(--sp-4) var(--sp-5)', borderRadius: 'var(--r-md)', border: 'none', cursor: 'pointer',
                background: 'var(--bg-surface-raised)', boxShadow: 'var(--rim)', color: 'var(--text-primary)',
              }}>
                <Icon name={icon} size={20} color="var(--text-accent)" />
                <span style={{ flex: 1 }}>
                  <span style={{ display: 'block', font: 'var(--type-body-strong)' }}>{title}</span>
                  <span style={{ display: 'block', font: 'var(--type-caption)', color: 'var(--text-muted)' }}>{desc}</span>
                </span>
                <Icon name="chevron-left" size={18} color="var(--text-muted)" style={{ transform: 'rotate(180deg)' }} />
              </button>
            ))}
          </div>
        </Sheet>
      </div>
    </div>
  );
}

function HistoryScreen({ onBack, onCamera, onEdit, onExport }) {
  const [groups, setGroups] = React.useState(PC_HISTORY_SEED);
  const [filter, setFilter] = React.useState('all');
  const [open, setOpen] = React.useState(null);
  const [trash, setTrash] = React.useState(null);
  const total = groups.reduce((a, g) => a + g.items.length, 0);
  const keep = (it) => filter === 'all' || (filter === 'review' ? it.status === 'review' : true);
  const shown = groups.map((g) => ({ ...g, items: g.items.filter(keep) })).filter((g) => (filter === 'today' ? g.day.startsWith('Hôm nay') : true)).filter((g) => g.items.length);
  const remove = (id) => {
    const snapshot = groups;
    setGroups(groups.map((g) => ({ ...g, items: g.items.filter((i) => i.id !== id) })));
    setOpen(null); setTrash(snapshot);
    setTimeout(() => setTrash(null), 3200);
  };
  let n = 0;
  return (
    <div style={screenBase}>
      <StatusBar />
      <ScreenHeader title="Ảnh đã xử lý" meta={total + ' ảnh · lưu trên máy'} onBack={onBack} right={<IconButton icon="search" label="Tìm" variant="ghost" />} />
      <div style={{ display: 'flex', gap: 'var(--sp-4)', padding: '0 var(--gutter) var(--sp-6)', overflowX: 'auto', scrollbarWidth: 'none' }}>
        {[['all', 'Tất cả'], ['today', 'Hôm nay'], ['review', 'Cần xem lại']].map(([id, label]) => (
          <Chip key={id} size="sm" selected={filter === id} tone={id === 'review' ? 'caution' : 'default'} onClick={() => setFilter(id)}>{label}</Chip>
        ))}
      </div>
      <div style={{ flex: 1, overflowY: 'auto', padding: '0 var(--gutter)', scrollbarWidth: 'none' }}>
        {shown.map((g) => (
          <section key={g.day} style={{ marginBottom: 'var(--sp-8)' }}>
            <h2 style={groupLabel}>{g.day}</h2>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 'var(--grid-gap)' }}>
              {g.items.map((it) => { n += 1; const idx = n; return (
                <BatchThumb key={it.id} index={idx} status={it.status} shape={it.shape} onClick={() => setOpen({ ...it, n: idx })} />
              ); })}
            </div>
          </section>
        ))}
        {!shown.length ? <p style={{ font: 'var(--type-caption)', color: 'var(--text-muted)', padding: 'var(--sp-8) 0' }}>Chưa có ảnh nào trong mục này.</p> : null}
      </div>
      {trash ? (
        <div style={{ position: 'absolute', left: 0, right: 0, bottom: 'calc(var(--thumb-band) + var(--sp-6))', display: 'grid', placeItems: 'center', zIndex: 12 }}>
          <Toast icon="undo-2" actionLabel="Hoàn tác" onAction={() => { setGroups(trash); setTrash(null); }}>Đã xoá 1 ảnh</Toast>
        </div>
      ) : null}
      <ThumbBand scrim={false}>
        <Button variant="primary" size="lg" fullWidth iconLeft="camera" onClick={onCamera}>Mở camera</Button>
      </ThumbBand>
      <HomeIndicator />
      {open ? <ItemSheet item={open} onClose={() => setOpen(null)} onEdit={() => { setOpen(null); onEdit && onEdit(open.shape); }} onExport={() => { setOpen(null); onExport && onExport(); }} onDelete={() => remove(open.id)} /> : null}
    </div>
  );
}

/* ---------- 7 · Cài đặt ---------- */
const PC_PERF = [
  { id: 'balanced', name: 'Cân bằng', desc: 'Mặc định. Viền cập nhật đủ nhanh trên hầu hết máy.', meta: '360P · 1/3 FRAME' },
  { id: 'battery', name: 'Tiết kiệm pin', desc: 'Viền cập nhật thưa hơn, máy mát và pin lâu hơn.', meta: '270P · 1/5 FRAME' },
  { id: 'quality', name: 'Chất lượng cao', desc: 'Viền bám sát và mượt hơn. Nên dùng trên máy mạnh.', meta: '540P · 1/2 FRAME' },
];

function Group({ label, children, note }) {
  return (
    <section style={{ marginBottom: 'var(--sp-8)' }}>
      <h2 style={groupLabel}>{label}</h2>
      <div style={{ borderRadius: 'var(--r-md)', background: 'var(--bg-surface)', boxShadow: 'var(--rim)', overflow: 'hidden' }}>{children}</div>
      {note ? <p style={{ font: 'var(--type-caption)', color: 'var(--text-muted)', marginTop: 'var(--sp-5)', textWrap: 'pretty' }}>{note}</p> : null}
    </section>
  );
}

function Row({ title, desc, right, onClick, first }) {
  const Tag = onClick ? 'button' : 'div';
  return (
    <Tag type={onClick ? 'button' : undefined} onClick={onClick} style={{
      display: 'flex', alignItems: 'center', gap: 'var(--sp-5)', width: '100%', textAlign: 'left',
      minHeight: 'var(--touch-comfortable)', padding: 'var(--sp-5) var(--sp-6)', background: 'transparent',
      border: 'none', borderTop: first ? 'none' : '1px solid var(--border-hairline)',
      cursor: onClick ? 'pointer' : 'default', color: 'var(--text-primary)', font: 'inherit',
    }}>
      <span style={{ flex: 1, minWidth: 0 }}>
        <span style={{ display: 'block', font: 'var(--type-body)', color: 'var(--text-primary)' }}>{title}</span>
        {desc ? <span style={{ display: 'block', font: 'var(--type-caption)', color: 'var(--text-muted)', marginTop: 2, textWrap: 'pretty' }}>{desc}</span> : null}
      </span>
      {right}
    </Tag>
  );
}

function SettingsScreen({ perf = 'balanced', onPerf, onBack }) {
  const [platform, setPlatform] = React.useState('ios');
  return (
    <div style={screenBase}>
      <StatusBar />
      <ScreenHeader title="Cài đặt" meta="phiên bản 0.1.0" onBack={onBack} />
      <div style={{ flex: 1, overflowY: 'auto', padding: '0 var(--gutter) var(--sp-8)', scrollbarWidth: 'none' }}>
        <Group label="Chế độ hiệu năng" note="Chế độ này chỉ đổi tốc độ và độ phân giải của viền xem trước. Ảnh xuất ra luôn ở chất lượng cao nhất, chỉ khác thời gian xử lý.">
          {PC_PERF.map((p, i) => {
            const on = p.id === perf;
            return (
              <Row key={p.id} first={i === 0} title={p.name} desc={p.desc} onClick={() => onPerf && onPerf(p.id)}
                right={
                  <span style={{ display: 'flex', alignItems: 'center', gap: 'var(--sp-5)', flex: '0 0 auto' }}>
                    <span style={{ ...metaMono, color: on ? 'var(--text-accent)' : 'var(--text-muted)' }}>{p.meta}</span>
                    <span style={{
                      width: 22, height: 22, borderRadius: '50%', display: 'grid', placeItems: 'center',
                      background: on ? 'var(--contour-core)' : 'transparent',
                      boxShadow: on ? 'var(--glow-accent-soft)' : 'inset 0 0 0 1px var(--border-subtle)',
                    }}>{on ? <Icon name="check" size={13} color="var(--ink-950)" strokeWidth={3} /> : null}</span>
                  </span>
                } />
            );
          })}
        </Group>

        <Group label="Quyền truy cập">
          <Row first title="Camera" desc="Bắt buộc để chụp và xem viền real-time." right={<Badge tone="accent" dot>ĐÃ CẤP</Badge>} />
          <Row title="Thư viện ảnh" desc="Chỉ dùng khi bạn lưu ảnh vào máy." right={<Badge>KHI LƯU</Badge>} />
          <Row title="Mở cài đặt hệ thống" onClick={() => {}} right={<Icon name="chevron-left" size={18} color="var(--text-muted)" style={{ transform: 'rotate(180deg)' }} />} />
        </Group>

        <Group label="Mô hình tách nền" note="Không có bước tải mô hình từ máy chủ. Toàn bộ xử lý chạy trên máy, hoạt động cả khi không có mạng.">
          <div style={{ display: 'flex', gap: 'var(--sp-4)', padding: 'var(--sp-5) var(--sp-6)' }}>
            {[['ios', 'iOS'], ['android', 'Android']].map(([id, label]) => (
              <Chip key={id} size="sm" selected={platform === id} onClick={() => setPlatform(id)}>{label}</Chip>
            ))}
          </div>
          {platform === 'ios' ? <>
            <Row title="Đang dùng" right={<span style={metaMono}>VISION · SUBJECT LIFTING</span>} />
            <Row title="Nguồn" desc="API hệ thống, không đóng gói thêm dung lượng." right={<span style={metaMono}>IOS 17+ · 0 MB</span>} />
          </> : <>
            <Row title="Đang dùng" right={<span style={metaMono}>MODNET · TFLITE</span>} />
            <Row title="Nguồn" desc="Mô hình đóng gói sẵn trong ứng dụng." right={<span style={metaMono}>12.4 MB</span>} />
          </>}
        </Group>

        <Group label="Lưu trữ">
          <Row first title="Ảnh đã xử lý" right={<span style={metaMono}>42 ẢNH · 248 MB</span>} />
          <Row title="Đồng bộ đám mây" desc="Ảnh chỉ nằm trên máy của bạn." right={<span style={metaMono}>KHÔNG</span>} />
        </Group>
        <Button variant="danger" size="md" fullWidth iconLeft="x" onClick={() => {}}>Xoá dữ liệu tạm (64 MB)</Button>
        <p style={{ ...metaMono, color: 'var(--text-muted)', textAlign: 'center', marginTop: 'var(--sp-8)' }}>PRODUCTCAM 0.1.0 · OFFLINE</p>
      </div>
      <HomeIndicator />
    </div>
  );
}

Object.assign(window, { CameraScreen, ReviewScreen, EdgeRefineSheet, HistoryScreen, SettingsScreen, ItemSheet });
