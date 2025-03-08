# Getting started with PsWinDose

The first thing that needs to be done, is you need to bootstrap the environment using `Initialize-PsWinDose`. This will do the following:

**This must be run as an administrator!**

- Create PsWinDose folder in the root directory defined in the pswindose.settings.json file. Default is: "C:\\ProgramData\\PsWinDose".
  - _Note: If at anytime you need to re-initialize, either use the -force switch or delete the folder._
- Ensures Winget is installed
- Ensures the following package providers are installed:
  - Nuget
  - Chocolatey
- Marks PSGallery as a trusted repository
