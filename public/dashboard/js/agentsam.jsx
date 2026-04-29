
function AgentSamDrawer() {
  const [open, setOpen] = React.useState(true);
  const [mode] = React.useState("auto");
  const [prompt, setPrompt] = React.useState("");
  const [messages, setMessages] = React.useState([
    { role:"assistant", content:"Agent Sam is ready. I can help review applications, draft donor updates, improve animal bios, plan campaigns, and guide CMS edits." }
  ]);
  const [steps, setSteps] = React.useState([]);
  const [busy, setBusy] = React.useState(false);
  const [sessionId, setSessionId] = React.useState(null);
  const [menuOpen, setMenuOpen] = React.useState(false);
  const abortRef = React.useRef(null);

  React.useEffect(() => {
    const openDrawer = () => setOpen(true);
    window.addEventListener("agentsam:open", openDrawer);
    return () => window.removeEventListener("agentsam:open", openDrawer);
  }, []);

  function stopPrompt() {
    if (abortRef.current) {
      abortRef.current.abort();
      abortRef.current = null;
    }
    setBusy(false);
    setSteps(s => [...s, { title:"Stopped by user", status:"stopped" }]);
  }

  async function sendPrompt() {
    const text = prompt.trim();
    if (!text || busy) return;
    setPrompt("");
    setBusy(true);
    setMessages(m => [...m, { role:"user", content:text }]);
    setSteps([]);

    try {
      const controller = new AbortController();
      abortRef.current = controller;
      const res = await fetch("/api/agentsam/chat", {
        method:"POST",
        credentials:"include",
        headers:{ "Content-Type":"application/json" },
        body:JSON.stringify({ prompt:text, mode, session_id:sessionId, route_path:location.pathname + location.search }),
        signal:controller.signal
      });

      if (!res.ok || !res.body) throw new Error("Agent Sam request failed.");

      const reader = res.body.getReader();
      const decoder = new TextDecoder();
      let buffer = "";

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        buffer += decoder.decode(value, { stream:true });

        const chunks = buffer.split("\n\n");
        buffer = chunks.pop() || "";

        for (const chunk of chunks) {
          const eventLine = chunk.split("\n").find(l => l.startsWith("event:"));
          const dataLine = chunk.split("\n").find(l => l.startsWith("data:"));
          if (!dataLine) continue;

          const event = eventLine ? eventLine.replace("event:", "").trim() : "message";
          const data = JSON.parse(dataLine.replace("data:", "").trim());

          if (event === "step") setSteps(s => [...s, data]);
          if (event === "answer") {
            if (data.session_id) setSessionId(data.session_id);
            setMessages(m => [...m, { role:"assistant", content:data.content, meta:`${data.provider} · ${data.model_key}` }]);
          }
          if (event === "error") setMessages(m => [...m, { role:"assistant", content:`Agent Sam hit an error: ${data.error}` }]);
        }
      }
    } catch (err) {
      if (err && err.name === "AbortError") {
        setMessages(m => [...m, { role:"assistant", content:"Stopped. I paused the current Agent Sam run." }]);
      } else {
        setMessages(m => [...m, { role:"assistant", content:String(err.message || err) }]);
      }
    } finally {
      abortRef.current = null;
      setBusy(false);
    }
  }

  if (!open) {
    return React.createElement("aside", { style:{ width:56, borderLeft:`1px solid ${C.border}`, background:C.bg2, display:"flex", alignItems:"flex-start", justifyContent:"center", paddingTop:18 } },
      React.createElement("button", {
        onClick:()=>setOpen(true),
        title:"Open Agent Sam",
        style:{ width:38, height:38, borderRadius:12, border:`1px solid ${C.border}`, background:C.raised, color:C.purple, cursor:"pointer" }
      }, React.createElement(Icon, { name:"sparkles", size:18 }))
    );
  }

  return React.createElement("aside", { style:{ width:330, borderLeft:`1px solid ${C.border}`, background:C.bg2, display:"flex", flexDirection:"column", minHeight:0 } },
    React.createElement("div", { style:{ padding:16, borderBottom:`1px solid ${C.border}`, display:"flex", alignItems:"center", justifyContent:"space-between", gap:10 } },
      React.createElement("div", { style:{ display:"flex", alignItems:"center", gap:10 } },
        React.createElement("button", {
          onClick:()=>setOpen(false),
          title:"Collapse Agent Sam",
          style:{ width:34, height:34, borderRadius:12, border:`1px solid ${C.border}`, background:C.raised, color:C.textSec, display:"grid", placeItems:"center", cursor:"pointer" }
        },
          React.createElement(Icon, { name:"panel-right-close", size:17 })
        ),
        React.createElement("div", null,
          React.createElement("div", { style:{ fontWeight:800, color:C.text } }, "Agent Sam"),
          React.createElement("div", { style:{ fontSize:11, color:C.textSec } }, busy ? "Working..." : "Dashboard assistant")
        )
      ),
      null
    ),

    React.createElement("div", { style:{ flex:1, overflow:"auto", padding:14, display:"flex", flexDirection:"column", gap:10 } },
      steps.length > 0 && React.createElement("div", { style:{ border:`1px solid ${C.border}`, borderRadius:14, padding:10, background:C.raised } },
        React.createElement("div", { style:{ fontWeight:800, fontSize:12, marginBottom:8, color:C.text } }, "Live steps"),
        steps.slice(-5).map((s,i) =>
          React.createElement("div", { key:i, style:{ display:"flex", gap:8, color:C.textSec, fontSize:12, marginTop:6 } },
            React.createElement(Icon, { name:"check", size:13 }),
            React.createElement("span", null, s.title || "Working")
          )
        )
      ),
      messages.map((m,i) =>
        React.createElement("div", { key:i, style:{ alignSelf:m.role==="user" ? "flex-end" : "flex-start", maxWidth:"92%" } },
          React.createElement("div", { style:{ padding:"10px 12px", borderRadius:14, background:m.role==="user" ? "rgba(124,58,237,.28)" : C.raised, border:`1px solid ${C.border}`, color:C.text, fontSize:13, lineHeight:1.5, whiteSpace:"pre-wrap" } }, m.content),
          m.meta && React.createElement("div", { style:{ color:C.textSec, fontSize:10, marginTop:4 } }, m.meta)
        )
      )
    ),

    React.createElement("div", { style:{ padding:12, borderTop:`1px solid ${C.border}` } },
      React.createElement("div", {
        style:{
          position:"relative",
          display:"flex",
          alignItems:"flex-end",
          gap:8,
          border:`1px solid ${C.border}`,
          background:C.bg,
          borderRadius:24,
          padding:"8px 8px 8px 10px",
          boxShadow:"0 12px 30px rgba(0,0,0,.18)"
        }
      },
        React.createElement("button", {
          type:"button",
          title:"Add files, images, or tools",
          onClick:()=>setMenuOpen(v=>!v),
          style:{
            width:34, height:34, borderRadius:17, border:`1px solid ${C.border}`,
            background:C.raised, color:C.textSec, display:"grid", placeItems:"center",
            cursor:"pointer", flexShrink:0
          }
        }, React.createElement(Icon, { name:"plus", size:17 })),

        menuOpen && React.createElement("div", {
          style:{
            position:"absolute",
            left:8,
            bottom:54,
            width:210,
            border:`1px solid ${C.border}`,
            background:C.bg2,
            borderRadius:16,
            padding:8,
            boxShadow:"0 18px 55px rgba(0,0,0,.35)",
            zIndex:20
          }
        },
          [
            ["paperclip", "Add file"],
            ["image", "Add image"],
            ["edit", "Website edit"],
            ["sparkles", "Generate campaign"],
            ["mail", "Draft response"]
          ].map(([icon,label]) =>
            React.createElement("button", {
              key:label,
              type:"button",
              onClick:()=>setMenuOpen(false),
              style:{
                width:"100%", display:"flex", alignItems:"center", gap:10,
                padding:"10px 11px", border:"none", borderRadius:12,
                background:"transparent", color:C.text, cursor:"pointer", textAlign:"left",
                fontWeight:700
              }
            }, React.createElement(Icon, { name:icon, size:15 }), React.createElement("span", null, label))
          )
        ),

        React.createElement("textarea", {
          value:prompt,
          onChange:e=>setPrompt(e.target.value),
          onKeyDown:e=>{ if(e.key==="Enter" && !e.shiftKey){ e.preventDefault(); sendPrompt(); } },
          placeholder:"Ask Agent Sam anything",
          rows:1,
          style:{
            flex:1,
            minHeight:34,
            maxHeight:110,
            resize:"none",
            border:"none",
            background:"transparent",
            color:C.text,
            padding:"8px 2px",
            outline:"none",
            fontFamily:"inherit",
            fontSize:13,
            lineHeight:1.35
          }
        }),

        React.createElement("button", {
          type:"button",
          title: busy ? "Stop Agent Sam" : "Send",
          onClick: busy ? stopPrompt : sendPrompt,
          disabled:!busy && !prompt.trim(),
          style:{
            width:38,
            height:38,
            borderRadius:19,
            border:"none",
            background:busy ? "linear-gradient(135deg,#ef4444,#f87171)" : (!prompt.trim() ? C.raised : "linear-gradient(135deg,#7c3aed,#a78bfa)"),
            color:"#fff",
            display:"grid",
            placeItems:"center",
            cursor:(!busy && !prompt.trim()) ? "not-allowed" : "pointer",
            flexShrink:0,
            boxShadow: busy || prompt.trim() ? "0 10px 24px rgba(124,58,237,.25)" : "none"
          }
        }, React.createElement(Icon, { name:busy ? "stop" : "arrow-up", size:17 }))
      )
    )
  );
}
