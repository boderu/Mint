function handle_end_file(event)
        if event.reason == "eof"
        then
                mp.command("script-message celluloid-action win.quit")
        end
end

mp.register_event("end-file", handle_end_file)
