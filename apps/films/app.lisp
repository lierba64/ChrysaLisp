;import settings
(import 'sys/lisp.inc)
(import 'gui/lisp.inc)

(structure 'event 0
	(byte 'win_close)
	(byte 'win_next)
	(byte 'win_prev))

(defq images '(apps/films/captive.flm apps/films/cradle.flm) index 0 id t)

(ui-tree window (create-window window_flag_close) nil
	(ui-element image_flow (create-flow) ('flow_flags (bit-or flow_flag_down flow_flag_fillw))
		(ui-element _ (create-flow) ('flow_flags (bit-or flow_flag_right flow_flag_fillh)
				'color argb_green 'font (create-font "fonts/Entypo.otf" 32))
			(button-connect-click (ui-element _ (create-button) ('text "")) event_win_prev)
			(button-connect-click (ui-element _ (create-button) ('text "")) event_win_next))
		(ui-element frame (canvas-load (elem index images) load_flag_film))))

(window-set-title window (elem index images))
(window-connect-close window event_win_close)
(bind '(w h) (view-pref-size window))
(gui-add (view-change window 64 512 w h))

(defun win-refresh (_)
	(view-sub frame)
	(setq index _ frame (canvas-load (elem index images) load_flag_film))
	(view-layout (view-add-back image_flow frame))
	(view-dirty (window-set-title window (elem index images)))
	(bind '(x y _ _) (view-get-bounds window))
	(bind '(w h) (view-pref-size window))
	(view-dirty-all (view-change window x y w h)))

(while id
	(task-sleep 40000)
	(canvas-swap (canvas-next-frame frame))
	(while (defq msg (mail-trymail))
		(cond
			((eq (setq id (get-long msg ev_msg_target_id)) event_win_close)
				(setq id nil))
			((eq id event_win_next)
				(win-refresh (mod (inc index) (length images))))
			((eq id event_win_prev)
				(win-refresh (mod (add (dec index) (length images)) (length images))))
			(t (view-event window msg)))))
