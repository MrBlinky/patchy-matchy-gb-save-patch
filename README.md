# Patchy Matchy Save patch

Patchy Matchy for the Game Boy has  17 achievement that must be unlocked in one
play session as unlocked achiements are not saved when power is turned off.
This may be quite a challenge for the casual player so I made this patch that
will save and load unlocked achievments to (battery backed up) save ram.

Loading unlocked achievements from save ram can be prevented by pressing down
both the START and SELECT buttons while powering on / reset the console. The 
START and SELECT buttons can be released when the MODRETRO logo appears.

### Supported game
| Title                                | SHA-1                                    |
| ------------------------------------ | ---------------------------------------- |
| Patchy Matchy                        | f26be04f250ce1b977565a7ca090ca6e87c5848c |

### Patching

An IPS patch file is included and can be applied using your favorite (online)
IPS patcher. If you want to to build the patch from source then RGBASM is
required. Put the files of this repo in a folder structure like this:

<pre>
.\rgbasm                               Folder containing RGBASM executables.
.\patches\patchy-matchy-gb-save-patch  Folder to put the files of this repo.
</pre>

Put the 'patchymatchy.gb' rom in the project folder and run patch-rom.bat
a copy of the rom is patched and saved with 'save patch' appended to the filename.
