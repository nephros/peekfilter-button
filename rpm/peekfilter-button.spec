# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
# 

Name:       peekfilter-button

# >> macros
# << macros
%define theme sailfish-default

Summary:    Configure Edge Swipes
Version:    0.11.0
Release:    1
Group:      Applications
License:    ASL 2.0
BuildArch:  noarch
URL:        https://github.com/nephros/peekfilter-button
Source0:    %{name}-%{version}.tar.gz
Source100:  peekfilter-button.yaml
BuildRequires:  qt5-qmake
BuildRequires:  sailfish-svg2png
BuildRequires:  qt5-qttools-linguist
BuildRequires:  qml-rpm-macros

%description
Adds a Settings entry to configure and a Top Menu switch to disable edge swipes.

%if "%{?vendor}" == "chum"
Title: Edge Swipe Control
Type: desktop-application
DeveloperName: nephros
Categories:
  - System
  - Settings
Custom:
  Repo: %{url}
  DescriptionMD: %{url}/raw/master/README.md
Screenshots:
  - %{url}/raw/master/Screenshot_001.png
  - %{url}/raw/master/Screenshot_002.png
  - %{url}/raw/master/Screenshot_003.png
Links:
  Homepage: %{url}
  Help: https://forum.sailfishos.org/t/14209
  Bugtracker: %{url}/issues
  Donation: https://openrepos.net/donate
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
# mangle version info
sed -i -e "s/@@UNRELEASED@@/%{version}-%{release}/" %{buildroot}%{_datadir}/jolla-settings/pages/%{name}/EnableSwitch.qml
# << install post

%files
%defattr(-,root,root,-)
%{_datadir}/jolla-settings/entries/%{name}.json
%{_datadir}/jolla-settings/pages/%{name}/EnableSwitch.qml
%{_datadir}/jolla-settings/pages/%{name}/PeekSlider.qml
%{_datadir}/jolla-settings/pages/%{name}/mainpage.qml
%{_datadir}/jolla-settings/pages/%{name}/AdvancedPage.qml
%{_datadir}/translations/*.qm
%{_datadir}/themes/%{theme}/meegotouch/z*/icons/*.png
# >> files
# << files
