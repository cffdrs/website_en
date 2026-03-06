<a href="https://cffdrs.github.io/website_fr/accueil/" target="_self" style="float: right;"> Français </a>

# Home

## About

The [Canadian Forest Fire Danger Rating System (CFFDRS)](https://natural-resources.canada.ca/our-natural-resources/forests/wildland-fires-insects-disturbances/canadian-forest-fire-danger-rating-system/14470) is the principal source of fire information for all [wildland fire management agencies](https://ciffc.ca/mobilization-stats/member-agencies) across Canada. It has widespread use as a regional and fireline safety and awareness tool. The CFFDRS is undergoing extensive revisions under the name [Next Generation CFFDRS (NG-CFFDRS)](https://ostrnrcan-dostrncan.canada.ca/handle/1845/245411), with rollout to practitioners occurring during 2024, 2025, and beyond. The primary goal is update the System to allow for the use of modern technology and data sources while maintaining its original simplicity and effectiveness.

This website is intended to:

- inform users about the ongoing changes to the CFFDRS
- centralize access to the code and documentation
- host tutorials for new users in multiple programming languages

Join our 
<a href="../resources/#sign-up" target="_self">newsletter mailing list</a> to get email updates about the latest developments with CFFDRS2025.

For those unfamiliar with the CFFDRS, or for official information regarding wildfires in Canada, read more on official Government of Canada pages under 
<a href="../resources/#links" target="_self">Resources#Links</a>.  

---

## Announcements

### February 2026
Over the past six weeks, the Fire Danger Group delivered three in‑person FWI2025 workshops across the country. Each session focused on presenting the system updates, introducing the new grassland fire danger components, and sharing a proposed national fire danger classification method.

A code update has been released focused on updating the methods to convert daily weather data to hourly. A new tutorial for it can be found <a href="../tutorials/#daily-to-hourly" target="_self">here</a>. More update details can be found on the [GitHub changelog](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/CHANGELOG.md#2026-02-27).

### Past Announcements

#### December 2025
A code update has been released so all calculations now account for leap years and have moved from defining seasonal transition dates as a Julian Date to a calendar date. The C version has also been further improved to match the Python and R versions. Details can be found on the [GitHub changelog](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/CHANGELOG.md#2025-12-10) including new options to run continuously over multiple years and not have grassland fuels transition from matted to standing.
 
Along with this code update, the C version now has a <a href="../code/#fwi2025" target="_self">code page</a> on this website, along with a <a href="../tutorials/#hourly-fwi" target="_self">tutorial</a> to calculate hourly FWI.

#### October 2025
The FWI2025 information report has been published, and is titled <a href="../resources/#reports" target="_self">The 2025 Update to the FWI System: Structure, Changes and Interpretation</a> (GLC-X-42). It provides information on the FWI2025 and the changes from the previous FWI1987 version, and can be found on the [NRCan Open S&T Repository](https://ostrnrcan-dostrncan.canada.ca/home). Additionally, a new informational video that explains the FWI2025 in general is now available on the <a href="../resources/#explainers" target="_self">resources page</a>.

The C code has been updated to now mostly match the Python and R versions. Details can be found on the [GitHub changelog](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/CHANGELOG.md#2025-10-02) along with more recent, minor bug fixes.

#### September 2025
A major code update for FWI2025 has been released to the [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng). It includes changes to the options when running `hFWI()`, the repository file structure, and how DMC and solar radiation are calculated. More details and the rest of the changes can be found on the [GitHub changelog](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/CHANGELOG.md#2025-09-10). This website has also been updated to have up-to-date <a href="../code" target="_self">documentation in Code</a> and <a href="../tutorials" target="_self">Tutorials</a>.

#### August 2025
A minor update has been released to the cffdrs-ng GitHub repository. The specific changes can be found on the [GitHub changelog](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/CHANGELOG.md#2025-08-22), which also includes extra details about the next (to be released) update. A running <a href="../code/#capabilities" target="_self">list of capabilities</a> is now available.

Natasha Jurko and Gabrielle Ayres hosted the second Fire Danger Group webinar about the new FWI2025 changes in comparison to the FWI1987 version. The recording is available on the <a href="../resources/#seminar-series" target="_self">Resources page</a>.

#### June 2025
We have recently updated the cffdrs-ng GitHub repository [README](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main?tab=readme-ov-file#readme) description and [contributing guidelines](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/CONTRIBUTING.md) (how to provide code feedback and bug reports). Coming soon, we will be releasing our list of capabilities, FAQ, and roadmap detailing our code updating process for CFFDRS2025. And as always, you can contact us with your ideas and general inquiries at our team email:
 
[firedanger-dangerincendie@nrcan-rncan.gc.ca](mailto:firedanger-dangerincendie@nrcan-rncan.gc.ca)

#### May 2025
Natasha Jurko and Sam LaCarte hosted a <a href="../resources/#grasslands-in-the-fire-weather-index-system-may-2025" target="_self">webinar</a> introducing the grassland components of the NG-FWI (FWI2025) on May 22nd. This was the first of a series of webinars designed to facilitate discussions with the Fire Danger Group. The recording will be made publicly available on this website at the beginning of June. In the meantime, you can <a href="../contact" target="_self">email us</a> if you would like to have access to the recording.

#### March 2025
The first edition of the newsletter is available now under
<a href="../resources/#newsletter" target="_self"> Resources#Newsletter</a>.
It goes over the new features of the Fire Weather Index (FWI2025) including the ability to use hourly data and the introduction of outputs for grasslands.

#### January 2025
The NG-CFFDRS Fire Weather Index (FWI) System module is available for users to test. Release of the other modules of the CFFDRS (e.g. FBP System, FMS, and FOP System) is ongoing.

---

## FAQ

- <a href="#can-fwi2025-be-used-with-the-current-fbp-system" target="_self">Can FWI2025 be used with the current FBP system?</a>
- <a href="#why-is-timezone-required-and-how-do-i-determine-it" target="_self">Why is timezone required and how do I determine it?</a>

<br>

#### Can FWI2025 be used with the current FBP system?

*As of February 2026:*

Feedback from users is crucial, and to that effect – we have heard valuable feedback on the compatibility between the Fire Weather Index 2025 (FWI2025) System and the current Fire Behaviour Prediction (FBP) System that needs to be addressed. FWI2025 is related to a new danger-rating system. It has not yet been linked to absolute (rather than relative) quantities of fire behaviour prediction and therefore should not be used with FBP1992 at this time. Linking of FWI2025 and fire behaviour prediction will come with (interim) iFBP2025. As for what agencies can do, they can implement FWI2025 in parallel with FWI1987 to take advantage of its new capabilities and help us with ongoing testing. Some of those new capabilities include:

- Tracking moisture in fast drying fine fuels like the Fine Fuel Moisture Code
- Provide indication of overnight burning
- Better indicators for ignition, spread and intensity with the Grassland FWI System components (Grassland Fuel Moisture Code, Grassland Spread Index, Grassland Fire Weather Index)
- Better indicator of peak fire danger with calculations of the FWI System components in near-real time

For FBP inputs, they should continue to use FWI1987 for operational decisions, though testing FWI2025 with FBP1992 and providing feedback would be valuable. Work is ongoing to quantify the differences between FWI2025 and FWI1987 in relation to the effect on fire behaviour using the current FBP System (FBP1992). We will communicate our findings this spring via our communication channels.  But, at this time, **FWI2025 should not be used as an input to the FBP System**.  

<br>

#### Why is timezone required and how do I determine it?
`timezone` is one of the required parameters to run FWI2025. More specifically, it is the UTC offset corresponding to the times in a dataset, and should be given in units of hours. It is required because it is an essential piece of information to be able to calculate sunrise and sunset times, along with latitude and longitude.  

If you know your weather data was collected in Local Standard Time (LST), the `timezone` parameter is simply the [UTC offset of the LST](https://en.wikipedia.org/wiki/List_of_UTC_offsets). This is true for any dataset that followed the [old CFFDRS standard](https://ostrnrcan-dostrncan.canada.ca/handle/1845/219568) of collecting daily weather data at noon LST. For example, [Eastern Standard Time](https://en.wikipedia.org/wiki/Eastern_Time_Zone) is 5 hours behind Coordinated Universal Time (UTC), which corresponds to a `timezone` input of -5. To find the UTC offset of a date and location programmatically, see the corresponding FWI2025 tutorial appendices for <a href="../tutorials/Hourly_FWI_Python/#appendix-timezone" target="_self">Python</a> and <a href="../tutorials/Hourly_FWI_R/#appendix-timezone" target="_self">R</a>.  

The other common practise for weather data is to collect it in UTC. In this case, `timezone` should be set to 0. If you know a dataset was collected in Local Daylight Time (LDT), this should be one hour ahead of LST, so add 1 to the UTC offset of the LST.  

If you do not know the UTC offset used for a dataset, the only thing you can do is guess what it is based on the diurnal fluctuations of the weather variables. Feel free to <a href="../contact" target = "_self">contact us</a> for more information or guidance.
