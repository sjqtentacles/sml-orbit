# sml-orbit

[![CI](https://github.com/sjqtentacles/sml-orbit/actions/workflows/ci.yml/badge.svg)](https://github.com/sjqtentacles/sml-orbit/actions/workflows/ci.yml)

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

## Example

`make example` builds and runs [`examples/demo.sml`](examples/demo.sml), which
propagates a fixed circular LEO orbit and computes a Hohmann transfer, a
bi-elliptic transfer, a Tsiolkovsky rocket delta-v budget, and Earth's sphere
of influence, all from literal fixed orbital elements (output is
byte-identical under MLton and Poly/ML):

```
LEO circular orbit, r = a = 6778.137 km (400 km altitude):
  circularV        = 7668.558 m/s
  visViva (r=a)    = 7668.558 m/s (matches circularV)
  escapeV          = 10844.979 m/s
  period           = 5553.624 s (92.560 min)
  specificEnergy   = ~29403392.245 J/kg

Hohmann transfer LEO (r1 = 6778.137 km) -> GEO (r2 = 42164 km):
  dv1              = 2397.470 m/s
  dv2              = 1456.487 m/s
  dvTotal          = 3853.957 m/s
  time of flight   = 19048.483 s (5.291 h)

Bi-elliptic transfer LEO -> GEO via burn radius rb = 100000 km:
  dv1              = 2826.565 m/s
  dv2              = 826.285 m/s
  dv3              = ~572.186 m/s
  dvTotal          = 4225.036 m/s (vs. Hohmann's 3853.957)

Tsiolkovsky rocket equation, isp = 311 s, m0 = 25000 kg, mf = 5000 kg:
  tsiolkovsky      = 4908.573 m/s
  tsiolkovskyVe    = 4908.573 m/s (ve = g0*isp; matches)

Earth's sphere of influence around the Sun (a = 1 AU):
  soiRadius        = 924554.650 km
```

## Install / Build / Test

```
$ cd sml-orbit
$ make all-tests
```
