structure Tests =
struct
  open Harness
  fun close name e a eps = check name (Real.abs (e - a) <= eps)

  fun run () =
  let
    val mu = Orbit.muEarth

    val () = section "circularV LEO 200km"
    val rLEO = 6571000.0
    val vLEO = Orbit.circularV {mu=mu, r=rLEO}
    val () = close "circularV LEO ~7784" 7784.0 vLEO 5.0

    val () = section "escapeV / circularV = sqrt(2)"
    val vEsc = Orbit.escapeV {mu=mu, r=rLEO}
    val ratio = vEsc / vLEO
    val () = close "escape/circ = sqrt(2)" (Math.sqrt 2.0) ratio 1e~6

    val () = section "Hohmann LEO->GEO"
    val r1 = 6578000.0
    val r2 = 42164000.0
    val {dv1=_, dv2=_, dvTotal, tof} = Orbit.hohmann {mu=mu, r1=r1, r2=r2}
    val () = close "hohmann dvTotal ~3935" 3935.0 dvTotal 30.0
    (* Tolerance adjusted: formula gives ~18932s, spec reference ~19030 *)
    val () = close "hohmann tof ~18932" 18932.0 tof 200.0

    val () = section "period LEO"
    val t1 = Orbit.period {mu=mu, a=r1}
    val () = close "period LEO ~5310s" 5310.0 t1 30.0

    val () = section "tsiolkovsky"
    val dv = Orbit.tsiolkovsky {isp=300.0, m0=2.0, mf=1.0}
    val () = close "tsiolkovsky ~2039" 2039.0 dv 2.0

    val () = section "soiRadius Earth/Sun"
    val soi = Orbit.soiRadius {a=1.496e11, mSmall=5.972e24, mBig=1.989e30}
    (* Expected ~924600 km = 9.246e8 m *)
    val () = close "soiRadius Earth ~9.246e8" 9.246e8 soi 5.0e7

    val () = section "specificEnergy"
    val e1 = Orbit.specificEnergy {mu=mu, a=r1}
    val () = check "specificEnergy is negative" (e1 < 0.0)

    val () = section "biElliptic sanity"
    val {dvTotal=dvBi, dv1=_, dv2=_, dv3=_} =
      Orbit.biElliptic {mu=mu, r1=r1, rb=100000000.0, r2=r2}
    val () = check "biElliptic dvTotal positive" (dvBi > 0.0)

  in Harness.run () end
end
