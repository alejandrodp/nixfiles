''
  # Fonts
  font_family      JetBrains Mono Medium
  bold_font        JetBrains Mono Bold
  italic_font      JetBrains Mono Italic
  bold_italic_font JetBrains Mono Bold Italic

  font_size 15
  disable_ligatures cursor

  initial_window_width  1200
  initial_window_height 600

  # Cursor
  cursor_shape beam
  cursor_beam_thickness 1.9
  cursor_stop_blinking_after 0
 
  # Audio
  enable_audio_bell no

  # Tabs
  tab_bar_style separator
  tab_separator " | "
  tab_title_template "{index}: {title}"

  # Color
  # special
  foreground       #ffffff
  foreground_bold  #ffffff
  cursor           #ffffff
  background       #000000
  background_opacity 1

  # Shortcuts
  map ctrl+shift+c copy_to_clipboard
  map ctrl+shift+v paste_from_clipboard
  map ctrl+shift+s paste_from_selection
  map shift+insert paste_from_selection

  map ctrl+shift+up scroll_line_up
  map ctrl+shift+down scroll_line_down
  map ctrl+shift+page_up scroll_page_up
  map ctrl+shift+page_down scroll_page_down
  map ctrl+shift+home scroll_home
  map ctrl+shift+end scroll_end

  map ctrl+shift+enter new_window
  map ctrl+alt+enter    launch --cwd=current
  map ctrl+shift+w close_window
  map ctrl+shift+] next_window
  map ctrl+shift+[ previous_window
  map ctrl+shift+1 first_window
  map ctrl+shift+2 second_window
  map ctrl+shift+3 third_window
  map ctrl+shift+4 fourth_window
  map ctrl+shift+5 fifth_window
  map ctrl+shift+6 sixth_window
  map ctrl+shift+7 seventh_window
  map ctrl+shift+8 eighth_window
  map ctrl+shift+9 ninth_window
  map ctrl+shift+0 tenth_window

  map ctrl+shift+right next_tab
  map ctrl+shift+left previous_tab
  map ctrl+shift+t new_tab
  map ctrl+shift+q close_tab
  map ctrl+shift+. move_tab_forward
  map ctrl+shift+, move_tab_backward
  map ctrl+shift+alt+t set_tab_title
  map ctrl+alt+1 goto_tab 1
  map ctrl+alt+2 goto_tab 2
  map ctrl+alt+3 goto_tab 3
  map ctrl+alt+4 goto_tab 4
  map ctrl+alt+5 goto_tab 5
  map ctrl+alt+6 goto_tab 6
  map ctrl+alt+7 goto_tab 7
  map ctrl+alt+8 goto_tab 8
  map ctrl+alt+9 goto_tab 9
  map ctrl+alt+0 goto_tab 10

  map ctrl+shift+equal change_font_size all +1.0
  map ctrl+shift+minus change_font_size all -1.0
  map ctrl+shift+backspace change_font_size all 0

  map ctrl+shift+delete clear_terminal reset active
''
