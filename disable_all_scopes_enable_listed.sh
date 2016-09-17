#!/bin/sh

#############
# http://blog.metajiji.tk/2015/07/ubuntu-1404-dash.html #
##############
 
[ $(id -u) -eq 0 ] && echo 'Please run from NOT root user!' && exit 1
 
# Delete unwanted packages.
sudo apt-get purge -y unity-lens-shopping unity-lens-friends unity-scope-video-remote unity-lens-music unity-lens-photos unity-webapps-common
 
# Disable online search.
gsettings set com.canonical.Unity.Lenses remote-content-search none
 
# Manually remove the link from dash.
sudo rm /usr/share/applications/ubuntu-amazon-default.desktop
 
get_application() {
 find /usr/share/unity/scopes/ \( \
   -name "*.scope" \
   -not -name 'applications.scope' \
  \) -printf "'%P'," | sed 's/\//-/g;s/,$//'
}
 
# Disabling the scopes.
gsettings set com.canonical.Unity.Lenses disabled-scopes "[$(get_application)]"
gsettings get com.canonical.Unity.Lenses disabled-scopes
 
gsettings set com.canonical.Unity.Lenses always-search "['applications.scope']"
gsettings set com.canonical.Unity.Dash scopes "['home.scope', 'applications.scope']"
 
# Disable available apps.
gsettings set com.canonical.Unity.ApplicationsLens display-available-apps "false"
