#!/usr/bin/wish

#################################################
# Spec.tcl - tool for writing a nuspec file
# by tony baldwin | http://wiki.tonybaldwin.info
# released according to GPL v.3 or later.

# require stuff
package require Tk
package require Ttk

# declare some variables
global name
global version
global author
global owners
global owner
global copyright
global purl
global iconurl
global licurl
global licacc
global summary
global description
global releasenotes
global tags
global filename
global file_types
global lica
global file
global target
global depends
global depversion

set file_types {
{"nuspec files" {.nuspec}}
{"all files" *}
}
set filename ""
set tags ""
set name ""
set version ""
set author ""
set owners ""
set owner ""
set copyright ""
set purl ""
set iconurl ""
set licurl ""
set licacc ""
set summary ""
set description ""
set releasenotes ""
set file ""
set target ""
set depends ""
set depversion ""

# gui starts here
wm title . "SpecTcl"

bind . <Escape> {exit}

frame .a
grid [ttk::label .a.namelabel -text "Name: "]\
[ttk::entry .a.nameentry -textvar name]

grid [ttk::label .a.vlabel -text "Version: "]\
[ttk::entry .a.ventry -textvar version]

grid [ttk::label .a.authlbl -text "Author(s): "]\
[ttk::entry .a.authen -textvar author]

grid [ttk::label .a.ownlbl -text "Owner(s): "]\
[ttk::entry .a.ownent -textvar owner]

grid [ttk::label .a.copy -text "Copyright: "]\
[ttk::entry .a.cpent -textvar copyright]

grid [ttk::label .a.proweb -text "Project Website: "]\
[ttk::entry .a.projurl -textvar purl]

grid [ttk::label .a.tg -text "Tags: "]\
[ttk::entry .a.tags -textvar tags]

grid [ttk::label .a.icolbl -text "Icon URL: "]\
[ttk::entry .a.icurl -textvar iconurl]

grid [ttk::label .a.deps -text "Dependencies: "]\
[ttk::entry .a.depent -textvar depends]

grid [ttk::label .a.depv -text "Depends Version: "]\
[ttk::entry .a.depvent -textvar depversion]

grid [ttk::label .a.file -text "File: "]\
[ttk::entry .a.enfil -textvar file]

grid [ttk::label .a.targ -text "Target: "]\
[ttk::entry .a.targent -textvar target]

grid [ttk::label .a.licweb -text "License URL: "]\
[ttk::entry .a.licurl -textvar licurl]

grid [ttk::label .a.lbl -text "Require license\nacceptance? "]\
[ttk::checkbutton .a.license -variable licacc]

pack .a -in . -side top

frame .b

frame .b.sum
ttk::label .b.sum.sl -text "Summary: "
text .b.sum.txt -width 35 -height 3 -wrap word
pack .b.sum.sl -in .b.sum -side top
pack .b.sum.txt -in .b.sum -side top

frame .b.desc
ttk::label .b.desc.lbl -text "Description:  "
text .b.desc.txt -width 35 -height 3 -wrap word
pack .b.desc.lbl -in .b.desc -side top
pack .b.desc.txt -in .b.desc -side top


frame .b.reln
ttk::label .b.reln.lbl -text "Release notes:  "
text .b.reln.txt -width 35 -height 3 -wrap word
pack .b.reln.lbl -in .b.reln -side top
pack .b.reln.txt -in .b.reln -side top

pack .b.desc -in .b -side top
pack .b.sum -in .b -side top
pack .b.reln -in .b -side top
pack .b -in . -side top

frame .c
grid [ttk::button .c.b -text "Create nuspec file" -command {mkspec}]
pack .c -in . -side bottom

# write the nuspec file
proc mkspec {} {
	if { $::licacc == "1" } {
		set lica true } else {
		set lica false
	}
	set ::summary "[.b.sum.txt get 1.0 {end -1c}]"
	set ::description "[.b.desc.txt get 1.0 {end -1c}]"
	set ::releasenotes "[.b.reln.txt get 1.0 {end -1c}]" 
set nuspec "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<package xmlns=\"http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd\">
  <metadata>
    <id>$::name</id>
    <title>$::name</title>
    <version>$::version</version>
    <authors>$::author</authors>
    <owners>$::owner</owners>
    <summary>$::summary</summary>
    <description>$::description</description>
    <projectUrl>$::purl</projectUrl>
    <tags>$::name $::tags admin</tags>
    <copyright>$::copyright</copyright>
    <licenseUrl>$::licurl</licenseUrl>
    <requireLicenseAcceptance>$lica</requireLicenseAcceptance>
    <iconUrl>$::iconurl</iconUrl>
    <dependencies>
      <dependency id=\"$::depends\" version=\"$::depversion\" />
    </dependencies>
    <releaseNotes>$::releasenotes</releaseNotes>
  </metadata>
  <files>
    <file src=\"$::file\" target=\"$::target\" />
  </files>
</package>"

toplevel .spectacle

frame .spectacle.a
text .spectacle.a.txt -width 50 -height 20 -yscrollcommand ".spectacle.a.ys set" -maxundo 0 -undo true
.spectacle.a.txt insert end $nuspec 

scrollbar .spectacle.a.ys -command ".spectacle.a.txt yview"

frame .spectacle.b
ttk::button .spectacle.b.btn -text "Save" -command {save}

pack .spectacle.a.txt -in .spectacle.a -side left -fill both -expand true
pack .spectacle.a.ys -in .spectacle.a -side left -fill y
pack .spectacle.a -in .spectacle -side top
pack .spectacle.b.btn -in .spectacle.b -side bottom
pack .spectacle.b -in .spectacle -side right

}

# save the nuspec file
proc save {} {
   set filename $::name.nuspec
   set filename [tk_getSaveFile -filetypes $::file_types]
   set data [.spectacle.a.txt get 1.0 {end -1c}]
   set fileid [open $filename w]
   puts -nonewline $fileid $data
   close $fileid
 } 

###############################################################
# This program was written by tony baldwin | http://wiki.tonybaldwin.info
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
