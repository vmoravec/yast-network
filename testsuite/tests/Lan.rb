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
module Yast
  class LanClient < Client
    def main
      Yast.include self, "testsuite.rb"

      DUMP("Disabled")
      return

      @READ = {
        "target"    => { "size" => 1, "tmpdir" => "/tmp", "string" => "Blah\n" },
        "init"      => { "scripts" => { "exists" => true } },
        "etc"       => {
          "resolv_conf" => {
            "nameserver" => ["1.2.3.4", "5.6.7.8"],
            "search"     => ["suse.cz", "suse.de"],
            "domain"     => "blah"
          }
        },
        "probe"     => { "system" => [] },
        "product"   => {
          "features" => {
            "USE_DESKTOP_SCHEDULER" => "0",
            "ENABLE_AUTOLOGIN"      => "0",
            "EVMS_CONFIG"           => "0",
            "IO_SCHEDULER"          => "cfg",
            "UI_MODE"               => "expert"
          }
        },
        "sysconfig" => {
          "language" => {
            "RC_LANG"          => "",
            "DEFAULT_LANGUAGE" => "",
            "ROOT_USES_LANG"   => "no"
          },
          "console"  => { "CONSOLE_ENCODING" => "UTF-8" }
        }
      }

      @EXEC = { "target" => { "bash_output" => {} } }

      TESTSUITE_INIT([@READ, {}, @EXEC], nil)

      Yast.import "Lan"
      Yast.import "Progress"
      Progress.off

      DUMP("Read")
      #TEST(``(Lan::Read()), [READ], nil);

      DUMP("Write")
      #TEST(``(Lan::Write()), [], nil);

      @lan_settings = {
        "dns"        => {
          "dhcp_hostname" => false,
          "domain"        => "suse.com",
          "hostname"      => "nashif",
          "nameservers"   => ["10.0.0.1"],
          "searchlist"    => ["suse.com"]
        },
        "interfaces" => [
          {
            "STARTMODE" => "onboot",
            "BOOTPROTO" => "static",
            "BROADCAST" => "10.10.1.255",
            "IPADDR"    => "10.10.1.1",
            "NETMASK"   => "255.255.255.0",
            "NETWORK"   => "10.10.1.0",
            "UNIQUE"    => "",
            "device"    => "eth0",
            "module"    => "",
            "options"   => ""
          }
        ],
        "routing"    => {
          "routes"        => [
            {
              "destination" => "default",
              "device"      => "",
              "gateway"     => "10.10.0.8",
              "netmask"     => "0.0.0.0"
            }
          ],
          "ip_forwarding" => false
        }
      }

      DUMP("Import")
      #TEST(``(Lan::Import(lan_settings)), [], nil);

      DUMP("Export") 
      #TEST(``(Lan::Export()), [], nil);
    end
  end
end

Yast::LanClient.new.main
