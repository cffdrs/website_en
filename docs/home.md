<a href="https://cffdrs.github.io/website_fr/accueil/" target="_self" style="float: right;"> Français </a>

# Home

## About

The [Canadian Forest Fire Danger Rating System (CFFDRS)](https://natural-resources.canada.ca/our-natural-resources/forests/wildland-fires-insects-disturbances/canadian-forest-fire-danger-rating-system/14470) is the principal source of fire information for all [wildland fire management agencies](https://www.canada.ca/en/public-safety-canada/campaigns/wildfires/prov.html) across Canada. It has widespread use as a regional and fireline safety and awareness tool. The CFFDRS is undergoing extensive revisions under the name [Next Generation CFFDRS (NG-CFFDRS)](https://ostrnrcan-dostrncan.canada.ca/handle/1845/245411), with rollout to practitioners occurring during 2024, 2025, and beyond. The primary goal is to update the System to allow for the use of modern technology and data sources while maintaining its original simplicity and effectiveness.

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

### June 2026

Excel calculators are now available to calculate FWI2025 as an alternative to running the C, Python, or R code. They have a simple, visual interface to input weather data, but can only calculate FWI2025 for one station at a time. Find them on the <a href="../resources/#excel-calculators" target="_self">Resources</a> page along with a user manual and quick start video.

### Past Announcements

#### February 2026
Over the past six weeks, the Fire Danger Group delivered three in‑person FWI2025 workshops across the country. Each session focused on presenting the system updates, introducing the new grassland fire danger components, and sharing a proposed national fire danger classification method.

A code update has been released focused on updating the methods to convert daily weather data to hourly. A new tutorial for it can be found <a href="../tutorials/#daily-to-hourly" target="_self">here</a>. More update details can be found on the [GitHub changelog](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/CHANGELOG.md#2026-02-27).

#### Archive

- <a href="../home/2025_announcements" target="_self">2025</a>

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
