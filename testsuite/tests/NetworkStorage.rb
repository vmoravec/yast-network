# encoding: utf-8

#***************************************************************************
#
# Copyright (c) 2012 Novell, Inc.
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.   See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, contact Novell, Inc.
#
# To contact Novell about this file by physical or electronic mail,
# you may find current contact information at www.novell.com
#
#**************************************************************************
#
module Yast
  class NetworkStorageClient < Client
    def main
      # testedfiles: NetworkStorage.ycp
      Yast.include self, "testsuite.rb"

      Yast.import "Assert"

      @READ = { "target" => { "tmpdir" => "/tmp" } }
      @WRITE = {}
      @EXECUTE = MockBash("")

      TESTSUITE_INIT([@READ, @WRITE, @EXECUTE], nil)

      Yast.import "NetworkStorage"

      @EXECUTE = MockBash(
        "/dev/sda2 / ext3 rw,relatime,errors=continue,user_xattr,acl,commit=15,barrier=1,data=ordered 0 0"
      )
      TEST(lambda { Assert.Equal("/dev/sda2", NetworkStorage.getDevice("/")) }, [
        @READ,
        @WRITE,
        @EXECUTE
      ], nil)

      @EXECUTE = MockBash(
        "nfs.example.com:/home/ /home nfs4 rw,relatime,vers=4,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,port=0,timeo=600,retrans=2,sec=krb5i,clientaddr=10.0.2.2,minorversion=0,local_lock=none,addr=10.0.0.1 0 0"
      )
      TEST(lambda { Assert.Equal("nfs", NetworkStorage.getDevice("/home")) }, [
        @READ,
        @WRITE,
        @EXECUTE
      ], nil) 

      # FIXME polish it to really test it
      #
      # TEST(``(
      #         Assert::Equal(`nfs, NetworkStorage::isDiskOnNetwork("server:/export"))
      #         ), [READ, WRITE, EXECUTE], nil);
      #
      # TEST(``(
      #         Assert::Equal(`nfs, NetworkStorage::isDiskOnNetwork("server-v4:/"))
      #         ), [READ, WRITE, EXECUTE], nil);

      nil
    end

    def MockBash(stdout)
      {
        "target" => {
          "bash_output" => { "exit" => 0, "stdout" => stdout, "stderr" => "" }
        }
      }
    end
  end
end

Yast::NetworkStorageClient.new.main
