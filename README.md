# sml-orbit

A zero-dependency Standard ML library for orbital mechanics calculations. Covers vis-viva, Hohmann and bi-elliptic transfers, the Tsiolkovsky rocket equation, sphere of influence, and related astrodynamics utilities.

## API

| Function | Description |
|---|---|
| `muEarth : real` | Earth gravitational parameter, 3.986004418×10¹⁴ m³/s² |
| `muSun : real` | Sun gravitational parameter, 1.32712440018×10²⁰ m³/s² |
| `g0 : real` | Standard gravity, 9.80665 m/s² |
| `visViva {mu,r,a}` | Orbital speed (m/s) at radius `r` on ellipse with semi-major axis `a` |
| `circularV {mu,r}` | Circular orbital speed (m/s) at radius `r` |
| `escapeV {mu,r}` | Escape velocity (m/s) at radius `r` |
| `period {mu,a}` | Orbital period (s) for semi-major axis `a` |
| `specificEnergy {mu,a}` | Specific orbital energy (J/kg) |
| `hohmann {mu,r1,r2}` | Hohmann transfer delta-v components (m/s) and transfer time (s) |
| `biElliptic {mu,r1,rb,r2}` | Bi-elliptic transfer via burn radius `rb` |
| `tsiolkovsky {isp,m0,mf}` | Δv (m/s) from specific impulse `isp` (s) and mass ratio |
| `tsiolkovskyVe {ve,m0,mf}` | Δv (m/s) from exhaust velocity `ve` (m/s) |
| `soiRadius {a,mSmall,mBig}` | Sphere of influence radius (m) |

## Worked Example

```sml
(* LEO to GEO Hohmann transfer *)
val r1 = 6578000.0   (* 200 km altitude, m *)
val r2 = 42164000.0  (* GEO, m *)
val {dv1, dv2, dvTotal, tof} =
  Orbit.hohmann {mu=Orbit.muEarth, r1=r1, r2=r2}
(* dv1 ~ 2456 m/s, dv2 ~ 1479 m/s, dvTotal ~ 3935 m/s, tof ~ 18932 s *)
```

## Install / Build / Test

```
$ cd sml-orbit
$ make all-tests
```
