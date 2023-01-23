# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
# 

Name:       peekfilter-button

# >> macros
# << macros

Summary:    Configure Edge Swipes
Version:    0.9.4
Release:    1
Group:      Applications
License:    ASL 2.0
BuildArch:  noarch
URL:        https://github.com/nephros/peekfilter-button
Source0:    %{name}-%{version}.tar.gz
Source100:  peekfilter-button.yaml
BuildRequires:  qt5-qmake
BuildRequires:  qt5-qttools-linguist
BuildRequires:  qml-rpm-macros

%description
Adds a Settings entry to configure and a Top Menu switch to disable edge swipes.

This app serves two functions. One, it allows to set the peekBundaryWidth from
the Settings app.  
See https://docs.sailfishos.org/Reference/Sailfish_OS_Tips_and_Tricks/#easing-edge-swipe about that.

Two: say you are playing a game or are editing an image in some app, but
the edge swipe gets in the way and wants to minimize the app.  Simple,
swipe down the Top Menu, tap the switch, swipe up again.  
Problem goes away.

But DO remember to disable the switch again soon, else you will have a bad time interacting with SFOS ;)

%if "%{?vendor}" == "chum"
PackageName: Edge Swipe Control
Type: desktop-application
DeveloperName: nephros
Categories:
  - System
  - Settings
Custom:
  Repo: %{url}
Icon: https://sailfishos.org/content/sailfishos-docs//sailfish-content-graphics-default/latest/images/icon-m-gesture.svg
Screenshots:
  - %{url}/raw/master/Screenshot_001.png
  - %{url}/raw/master/Screenshot_002.png
  - %{url}/raw/master/Screenshot_003.png
Url:
  Homepage: %{url}
  Help: %{url}/issues
  Donations:
    - https://noyb.eu/en/donations-other-support-options
    - https://my.fsfe.org/donate
    - https://supporters.eff.org/donate/join-4
    - https://openrepos.net/donate
%endif


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5 

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

%files
%defattr(-,root,root,-)
%{_datadir}/jolla-settings/entries/%{name}.json
%{_datadir}/jolla-settings/pages/%{name}/EnableSwitch.qml
%{_datadir}/jolla-settings/pages/%{name}/PeekSlider.qml
%{_datadir}/jolla-settings/pages/%{name}/mainpage.qml
%{_datadir}/translations/*.qm
# >> files
# << files
