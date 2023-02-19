# Force Keyboard Layout for specific windows in Gnome3
Unfortunately soydevs cant deliver so we gotta do that thru some ass
# Project idea
I got pissed off with VNC windows that cant accept russian layout and block inputs instead (example: VMware or QEMU console VNC), those windows should always have english layout init. 
On top of that if you want to switch layout inside vnc session your host layout switches too and hence your input blocked. You can switch your remote system layout hotkey to Alt+Shift but then it becomes even more pain in the ass I found myself pressing both combos 4 times until i fucking figure out which layout is where
This is some honest piss take I cant let it be like that any longer
Thus these scripts were created.
# Project structure
Project consists of two perl scripts and one xbindkeys config. Xbindkeys is configured for Ctrl+Shift combination in both ways (Ctrl+Shift_L/Shift_L+Ctrl). If you need another combo you gotta grab it with `xbindkeys -k` command
### Why Ctrl+Shift ?
Because Alt+Shift is retarded shit. In windows it always highlights menu instead if switching layout. In linux can do that too. Who even uses such combo? Idk prolly some retards or other soydevs
### Why no Super+Space
It doesnt works with xbindkeys tho I think you can bind this combination in Gnome3 keyboard settings 
# How to make it work
1) Edit `bind.pl` and `service.pl`, decide on which layout index is considered main one and which window titles you want to force to become locked on main layout. There is a first list that is the actual filter for window titles and then secondary list is an exclusion of first filter. They called whitelist+blacklist. Should be flexible enuf this way
2) Disable wanted layout hotkey combo in Gnome3. If you have Ctrl+Shift enabled as your favorite one - disable it via gnome-tweaks
3) Put `.xbindkeysrc` to home directory and edit `~/.xbindkeysrc` to fix path to point it to the location of `bind.pl`
4) Obviously do `chmod +x` on both perl scripts
5) Install if not installed already `xbindkeys` like `apt install xbindkeys` or `pacman -S xbindkeys` or uno
6) Add xbindkeys to autostart somehow. It needs to start inside gnome not in rc.local. Maybe you need to create desktop file. Or add it to `.xinitrc`. I aint providing any nursery here sorry.
7) Start `xbindkeys` for current session just type it in terminal
8) Test your hotkey. Now it should toggle layout in all windows and force main layout in forbidden windows. Also now it does this much faster (thx soydevs)
9) If you want additional unfuckery you can enable `service.pl`. Make it autostart with gnome and it will protect you from human error, for example if you switch layout with mouse in system tray for forbidden app, it will revert layout back to forced one. Ffs for some reason it stabily works every even time and every odd time it does nothing because dbus events get swallowed. Idk why thanks Poettering and fuck this shit I had enuf of DBUS for now and its additional unfuckery anyways
# Bonus
Because you got rid of that soylent-inspired layout popup that pops up when you press Super+Space - your window focus wont get fucked up anymore when you switch layouts. Focus wont jump around anymore. This is utterly a good thing to know that you defeated that annoying retarded bug too for ya future piece of mind and joy of typing
# Bonus2
Ok I decided to attach my startup.desktop file, which is by concept is some sort of rc.local but for gnome-session. I find it convenient because I can patch that startup script anytime and even set the order of the startup apps. You can put all commands you need to that startup script and place desktop file once inside `~/.config/autostart/` folder.
Much better than fucking creating *.desktop files for each fucking shit like it is designed in gnome as some fucktarded "correct soy-way"
