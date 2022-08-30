/// Prepares a text to be used for maptext. Use this so it doesn't look hideous.
#define MAPTEXT(text) {"<span class='maptext'>[##text]</span>"}
#define MAPTEXT_REALLYBIG(text) {"<span class='maptext reallybig'>[##text]</span>"}
#define MAPTEXT_REALLYBIG_COLOR(text, color) {"<span class='maptext reallybig' style='color:[##color]'>[##text]</span>"}

/// Macro from Lummox used to get height from a MeasureText proc
#define WXH_TO_HEIGHT(x) text2num(copytext(x, findtextEx(x, "x") + 1))

// Used by PDA and cartridge code to reduce repetitiveness of spritesheets
#define PDAIMG(what) {"<span class="pda16x16 [#what]"></span>"}

/// Removes characters incompatible with file names.
#define SANITIZE_FILENAME(text) (GLOB.filename_forbidden_chars.Replace(text, ""))
