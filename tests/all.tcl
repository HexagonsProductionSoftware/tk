# all.tcl --
#
# This file contains a top-level script to run all of the Tk
# tests.  Execute it by invoking "source all.tcl" when running tktest
# in this directory.
#
# Copyright (c) 1998-1999 by Scriptics Corporation.
#
# See the file "license.terms" for information on usage and redistribution
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.

package require Tcl 8.4
package require tcltest 2.1
package require Tk ;# This is the Tk test suite; fail early if no Tk!
tcltest::configure -testdir [file join [pwd] [file dirname [info script]]]
tcltest::configure -singleproc 1
eval tcltest::configure $argv

# tcltest 2.2 sources the test files into this interpreter (-singleproc) without catching their
# errors: an error outside a test ends this script, and tktest then shows it in a message box and
# waits until someone closes it, which keeps a build waiting. Print the error and the test file,
# as tcltest does for a test file that exits with an error, and exit.
if {[catch {tcltest::runAllTests} msg]} {
    set info $::errorInfo
    # The outermost file in the error: the test file that runAllTests sourced.
    set file unknown
    regexp {.*\(file "([^"]+)" line [0-9]+\)} $info -> file
    puts [tcltest::outputChannel] "Test file error: $msg\n$info"
    puts [tcltest::outputChannel] "\nTest files exiting with errors:  \n"
    puts [tcltest::outputChannel] "  [file tail $file]\n"
    exit 1
}
