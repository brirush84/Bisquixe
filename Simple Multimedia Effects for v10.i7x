Version 6 of Simple Multimedia Effects for v10 by Mathbrush begins here.

[Significant chunks of code were first written by Petter Sjölund.]

Book 1 - CSS

Part 1 - Changing elements of classes

Css-element is some text that varies.

Css-property is some text that varies.

Css-value is some text that varies.

Css-element is ".WindowFrame".
Css-property is "background-color".
Css-value is "yellow".

Include (-
	[ glk_set_css_fast _vararg_count;
	  @glk 5377 _vararg_count 0;
	  return 0;
	];
	
	[ glk_set_css_slow _vararg_count;
	  @glk 5379 _vararg_count 0;
	  return 0;
	];

	[ glk_any_style _vararg_count;
	  @glk 5378 _vararg_count 0;
	  return 0;
	];

	[ glk_import_google_fonts _vararg_count;
	  @glk 5380 _vararg_count 0;
	  return 0;
	];

	[ glk_add_audio _vararg_count;
	  @glk 5381 _vararg_count 0;
	  return 0;
	];

	[ glk_add_image _vararg_count;
	  @glk 5382 _vararg_count 0;
	  return 0;
	];

	[ glk_internal_page _vararg_count;
	  @glk 5383 _vararg_count 0;
	  return 0;
	];
-)


To css-set-fast (Temp - a text):
	(-
	if(glk_gestalt(5376, 0)){
	glk_set_css_fast(Glulx_ChangeAnyToCString(TEXT_TY_Say, {Temp}));
	}
	-)

To css-set-slow (Temp - a text):
	(-
	if(glk_gestalt(5376, 0)){
	glk_set_css_slow(Glulx_ChangeAnyToCString(TEXT_TY_Say, {Temp}));
	}
	-)

To import-google-fonts (Temp - a text):
	(-
	if(glk_gestalt(5376, 0)){
	glk_import_google_fonts(Glulx_ChangeAnyToCString(TEXT_TY_Say, {Temp}));
	}
	-)
	
To upload-audio (Temp - a text) with internal name (Temp1 - a sound name):
	let tempid be the Glulx resource ID of Temp1;
	let tempname be "[temp].mp3";
	add-audio tempname with id tempid;

To add-audio (Temp - a text) with id (Temp1 - a number) :
	(-
	if(glk_gestalt(5376, 0)){
	glk_add_audio(Glulx_ChangeAnyToCString(TEXT_TY_Say, {Temp}), {Temp1});
	}
	-)

To add-image (Temp - a text) with alttext (tempalt - a text) with id (Temp1 - a number) with width (Temp2 - a number) with height (Temp3 - a number) :
	(-
	if(glk_gestalt(5376, 0)){
	glk_add_image({Temp1},Glulx_ChangeAnyToCString(TEXT_TY_Say, {Temp}),Glulx_ChangeAnyToCString(TEXT_TY_Say, {TempAlt}), {Temp2},{Temp3});
	}
	-)
	
Part 2 - Arbitrary styling

Section 1 - Class naming
		 
To set-any-class (Temp - a text):
	(- 
	
	if(glk_gestalt(5376, 0)){
	glk_any_style(Glulx_ChangeAnyToCString(TEXT_TY_Say, {Temp}),style_counter);
	style_counter++;
	}	
	-)
	
Every turn (this is the style_counter reset rule):
	reset-style;
	
To reset-style:
	(- style_counter = 10; -)


Book 2 - Links

Include Glulx Entry Points by Emily Short.

Section 1 - Initiation of links

To set echo line events off:
	(- if (glk_gestalt(gestalt_LineInputEcho, 0)) glk_set_echo_line_event(gg_mainwin,0); -)

Echoed already is a truth state that varies.

Include (-

Global echoed_already = 0;
Global style_counter = 11;

-) after "Definitions.i6t".

The echoed already variable translates into I6 as "echoed_already".

When play begins:
	set echo line events off;
	request glulx hyperlink event in main window;
	request glulx hyperlink event in status window.

A command-showing rule (this is the new print text to the input prompt rule):
	now echoed already is true;
	say "[input-style-for-glulx][Glulx replacement command][roman type][paragraph break]".

To say input-style-for-Glulx:
	(- glk_set_style(style_Input); -)

The new print text to the input prompt rule is listed instead of the print text to the input prompt rule in the command-showing rules.

Include (-

[ VM_KeyChar win nostat done res ix jx ch;
	jx = ch; ! squash compiler warnings
	if (win == 0) win = gg_mainwin;
	if (gg_commandstr ~= 0 && gg_command_reading ~= false) {
		done = glk_get_line_stream(gg_commandstr, gg_arguments, 31);
		if (done == 0) {
			glk_stream_close(gg_commandstr, 0);
			gg_commandstr = 0;
			gg_command_reading = false;
			! fall through to normal user input.
		} else {
			! Trim the trailing newline
			if (gg_arguments->(done-1) == 10) done = done-1;
			res = gg_arguments->0;
			if (res == '\') {
				res = 0;
				for (ix=1 : ix<done : ix++) {
					ch = gg_arguments->ix;
					if (ch >= '0' && ch <= '9') {
						@shiftl res 4 res;
						res = res + (ch-'0');
					} else if (ch >= 'a' && ch <= 'f') {
						@shiftl res 4 res;
						res = res + (ch+10-'a');
					} else if (ch >= 'A' && ch <= 'F') {
						@shiftl res 4 res;
						res = res + (ch+10-'A');
					}
				}
			}
			jump KCPContinue;
		}
	}
	done = false;
	glk_request_char_event(win);
	while (~~done) {
		glk_select(gg_event);
		switch (gg_event-->0) {
		  5: ! evtype_Arrange
			if (nostat) {
				glk_cancel_char_event(win);
				res = $80000000;
				done = true;
				break;
			}
			DrawStatusLine();
		  2: ! evtype_CharInput
			if (gg_event-->1 == win) {
				res = gg_event-->2;
				done = true;
				}
		}
		ix = HandleGlkEvent(gg_event, 1, gg_arguments);
		if (ix == 2) {
			res = gg_arguments-->0;
			done = true;
		} else if (ix == -1)  done = false;
	}
	if (gg_commandstr ~= 0 && gg_command_reading == false) {
		if (res < 32 || res >= 256 || (res == '\' or ' ')) {
			glk_put_char_stream(gg_commandstr, '\');
			done = 0;
			jx = res;
			for (ix=0 : ix<8 : ix++) {
				@ushiftr jx 28 ch;
				@shiftl jx 4 jx;
				ch = ch & $0F;
				if (ch ~= 0 || ix == 7) done = 1;
				if (done) {
					if (ch >= 0 && ch <= 9) ch = ch + '0';
					else					ch = (ch - 10) + 'A';
					glk_put_char_stream(gg_commandstr, ch);
				}
			}
		} else {
			glk_put_char_stream(gg_commandstr, res);
		}
		glk_put_char_stream(gg_commandstr, 10); ! newline
	}
  .KCPContinue;
	return res;
];
-) replacing "VM_KeyChar".

Include (-

[ VM_KeyDelay tenths  key done ix;
	glk_request_char_event(gg_mainwin);
	glk_request_timer_events(tenths*100);
	while (~~done) {
		glk_select(gg_event);
		ix = HandleGlkEvent(gg_event, 1, gg_arguments);
		if (ix == 2) {
			key = gg_arguments-->0;
			done = true;
		}
		else if (ix >= 0 && gg_event-->0 == 1 or 2) {
			key = gg_event-->2;
			done = true;
		}
	}
	glk_cancel_char_event(gg_mainwin);
	glk_request_timer_events(0);
	return key;
];
-) replacing "VM_KeyDelay".

Include (-

[ VM_ReadKeyboard  a_buffer a_table done ix;
	if (gg_commandstr ~= 0 && gg_command_reading ~= false) {
		done = glk_get_line_stream(gg_commandstr, a_buffer+WORDSIZE,
			(INPUT_BUFFER_LEN-WORDSIZE)-1);
		if (done == 0) {
			glk_stream_close(gg_commandstr, 0);
			gg_commandstr = 0;
			gg_command_reading = false;
		}
		else {
			! Trim the trailing newline
			if ((a_buffer+WORDSIZE)->(done-1) == 10) done = done-1;
			a_buffer-->0 = done;
			VM_Style(INPUT_VMSTY);
			glk_put_buffer(a_buffer+WORDSIZE, done);
			VM_Style(NORMAL_VMSTY);
			print "^";
			jump KPContinue;
		}
	}
	done = false;
	glk_request_line_event(gg_mainwin, a_buffer+WORDSIZE, INPUT_BUFFER_LEN-WORDSIZE, 0);
	while (~~done) {
		glk_select(gg_event);
		switch (gg_event-->0) {
		  5: ! evtype_Arrange
			DrawStatusLine();
		  3: ! evtype_LineInput
			if (gg_event-->1 == gg_mainwin) {
				a_buffer-->0 = gg_event-->2;
				done = true;
			}
		}
		ix = HandleGlkEvent(gg_event, 0, a_buffer);
		if (ix == 2) done = true;
		else if (ix == -1) done = false;
	}
	if (gg_commandstr ~= 0 && gg_command_reading == false) {
		glk_put_buffer_stream(gg_commandstr, a_buffer+WORDSIZE, a_buffer-->0);
		glk_put_char_stream(gg_commandstr, 10); ! newline
	}
  .KPContinue;
	VM_Tokenise(a_buffer,a_table);
	! It's time to close any quote window we've got going.
	if (gg_quotewin) {
		glk_window_close(gg_quotewin, 0);
		gg_quotewin = 0;
	}

	! === NEW ===

	if ((glk_gestalt(gestalt_LineInputEcho, 0)) && echoed_already == 0) {
		glk_set_style(style_Input);
		for (ix=WORDSIZE: ix<(a_buffer-->0)+WORDSIZE: ix++) print (char) a_buffer->ix;
		style roman;
		print "^";
	}
	echoed_already = 0;

	! === END ===

	#ifdef ECHO_COMMANDS;
	print "** ";
	for (ix=WORDSIZE: ix<(a_buffer-->0)+WORDSIZE: ix++) print (char) a_buffer->ix;
	print "^";
	#endif; ! ECHO_COMMANDS
];

-) replacing "VM_ReadKeyboard".

Section 2 - Event handling

A glulx hyperlink rule (this is the default inline hyperlink handling rule):
	now the current hyperlink ID is the link number of the selected hyperlink;
	unless the current hyperlink ID is 0:
		cancel glulx hyperlink request in main window;[just to be safe]
		cancel glulx hyperlink request in status window;[just to be safe]
		follow the hyperlink processing rules;
	if the status window is the hyperlink source:
		request glulx hyperlink event in status window;
	otherwise:
		request glulx hyperlink event in main window.

To request glulx hyperlink event in the/-- main window:
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_request_hyperlink_event(gg_mainwin); -)

To cancel glulx hyperlink request in the/-- main window:
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_cancel_hyperlink_event(gg_mainwin); -)

To request glulx hyperlink event in the/-- status window:
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)  && gg_statuswin) glk_request_hyperlink_event(gg_statuswin); -)
	
To cancel glulx hyperlink request in the/-- status window:
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0) && gg_statuswin) glk_cancel_hyperlink_event(gg_statuswin); -)

To decide whether the status window is the hyperlink source:
	(- (gg_event-->1==gg_statuswin) -)

To decide which number is the link/-- number of the/-- selected/clicked hyperlink:
	(- (gg_event-->2) -)

Section 3 - Placing links

The hyperlink list is a list of texts that vary..

To hyperlink (hyper-text - a text) as (hyper-command - a text):
	let hyperlink index be a number;
	if the hyper-command is listed in the hyperlink list:
		repeat with count running from 1 to the number of entries in the hyperlink list:
			if entry (count) of the hyperlink list is hyper-command:
				let hyperlink index be count;
	otherwise unless the hyper-command is "":
		add hyper-command to hyperlink list;
		let hyperlink index be the number of entries of hyperlink list;
	say "[set link (hyperlink index)][hyper-text][terminate link]";
		 
To say set link (N - a number):
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_set_hyperlink({N}); -)

To say terminate link:
	(-  if (glk_gestalt(gestalt_Hyperlinks, 0)) glk_set_hyperlink(0); -)

Section 4 - Processing hyperlinks

The hyperlink processing rules are a rulebook.

The current hyperlink ID is a number that varies.

Section 5 - Selecting replacement command

A hyperlink processing rule (this is the default command replacement by hyperlinks rule):  
	now the glulx replacement command is entry (current hyperlink ID) of the hyperlink list;
	rule succeeds.

Section 6 - Linking to internal pages

To link-page (Temp - a text) with tabOption (newTab - a number):
	(-
	if(glk_gestalt(5376, 0)){
	glk_internal_page(Glulx_ChangeAnyToCString(TEXT_TY_Say, {Temp}), {newTab});
	}
	-)
	
Simple Multimedia Effects for v10 ends here.
