signature ORBIT =
sig
  (* Standard gravitational parameters (m^3/s^2) *)
  val muEarth : real   (* 3.986004418e14 *)
  val muSun   : real   (* 1.32712440018e20 *)
  val g0      : real   (* 9.80665 m/s^2 standard gravity *)

  (* Vis-viva equation: speed at radius r on orbit with semi-major axis a, given mu *)
  val visViva       : {mu:real, r:real, a:real} -> real

  (* Circular orbital speed at radius r *)
  val circularV     : {mu:real, r:real} -> real

  (* Escape velocity at radius r *)
  val escapeV       : {mu:real, r:real} -> real

  (* Orbital period (seconds) for semi-major axis a *)
  val period        : {mu:real, a:real} -> real

  (* Specific orbital energy (J/kg) *)
  val specificEnergy : {mu:real, a:real} -> real

  (* Hohmann transfer between circular orbits r1 -> r2 *)
  val hohmann : {mu:real, r1:real, r2:real}
    -> {dv1:real, dv2:real, dvTotal:real, tof:real}

  (* Bi-elliptic transfer r1 -> rb (burn radius) -> r2 *)
  val biElliptic : {mu:real, r1:real, rb:real, r2:real}
    -> {dv1:real, dv2:real, dv3:real, dvTotal:real}

  (* Tsiolkovsky rocket equation: delta-v from specific impulse (s), initial and final mass *)
  val tsiolkovsky   : {isp:real, m0:real, mf:real} -> real
  (* Same but with effective exhaust velocity (m/s) instead of isp *)
  val tsiolkovskyVe : {ve:real, m0:real, mf:real} -> real

  (* Sphere of influence radius: a=semi-major axis, mSmall=planet mass, mBig=central mass *)
  val soiRadius     : {a:real, mSmall:real, mBig:real} -> real
end
