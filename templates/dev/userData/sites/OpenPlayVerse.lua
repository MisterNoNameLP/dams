local body = env.dyn.html.Body.new()

body:addHeader(2, "OpenPlayVerse")

body:addRaw([[
<span style="white-space: pre-line">
<b>About OpenPlayVerse</b>
OpenPlayVerse is a little community where everyone is welcome, as long as you dont try to seek trouble. :)

We are open for every kind of being. Including members of DID and tulpa systems, as well as other kinds of beings.
If system memebers wants to talk independently from each other in our chat rooms, it can be done utilizing a personality proxy.
We also have dedicaded rooms exclusively for tulpas and other kinds of "non humam" beings.

<b>What we do</b>
We are mostly about gaming / playing games together. 

We currently host our own Minecraf server with the Crusial2 modpack, wich is pretty lightweight and should run on most computers and laptops.

We are also open to play games like skribble, board games or gartic phone.

If you have any idears what games we could play too, please let us know.
We are willing to add new chat rooms for games to our game rooms category.

<b>Find your way to us</b>
If you want to go into our OpenPlayVerse you can go to our ]] .. body.addLink("https://discord.gg/TwzanjF7p4", "Discord server") .. [[. 
We hope to see you there! :)
</span>
]])


return body:generateCode()