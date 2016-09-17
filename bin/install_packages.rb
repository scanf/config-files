#!/usr/bin/ruby

unamestr = `uname`.strip
if unamestr.start_with?('Linux')
  distro_id = `lsb_release -i`.strip
  pm = "apt-get" # assuming Debian
  if distro_id.end_with?("Fedora")
   pm = "dnf"
  end

  system("sudo #{pm} update")
  system("sudo #{pm} install git vim")
  packages = File.readlines("PackagesList").join(" ").delete!("\n")
  system("sudo #{pm} install -y #{packages}")
  system("sudo #{pm} autoremove")

  if pm == "apt-get"
   system("sudo #{pm} autoclean")
  end
  system('locale-gen "en_US.UTF-8"')
  system("cd #{ENV['HOME']}/src/github.com/scanf/xcd.rb && /usr/bin/sudo make install")
end