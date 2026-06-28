structure Orbit :> ORBIT =
struct
  val muEarth = 3.986004418e14
  val muSun   = 1.32712440018e20
  val g0      = 9.80665

  fun visViva {mu, r, a} = Math.sqrt (mu * (2.0/r - 1.0/a))

  fun circularV {mu, r} = Math.sqrt (mu / r)

  fun escapeV {mu, r} = Math.sqrt (2.0 * mu / r)

  fun period {mu, a} = 2.0 * Math.pi * Math.sqrt (a * a * a / mu)

  fun specificEnergy {mu, a} = ~mu / (2.0 * a)

  fun hohmann {mu, r1, r2} =
    let val at   = (r1 + r2) / 2.0
        val v1   = circularV {mu=mu, r=r1}
        val vt1  = visViva {mu=mu, r=r1, a=at}
        val dv1  = vt1 - v1
        val vt2  = visViva {mu=mu, r=r2, a=at}
        val v2   = circularV {mu=mu, r=r2}
        val dv2  = v2 - vt2
        val dvT  = Real.abs dv1 + Real.abs dv2
        val tof  = Math.pi * Math.sqrt (at * at * at / mu)
    in {dv1=dv1, dv2=dv2, dvTotal=dvT, tof=tof} end

  fun biElliptic {mu, r1, rb, r2} =
    let (* First transfer orbit: r1 -> rb *)
        val at1  = (r1 + rb) / 2.0
        val v1   = circularV {mu=mu, r=r1}
        val vt1a = visViva {mu=mu, r=r1, a=at1}
        val dv1  = vt1a - v1
        (* At rb: burn between two transfer orbits *)
        val at2  = (rb + r2) / 2.0
        val vt1b = visViva {mu=mu, r=rb, a=at1}
        val vt2a = visViva {mu=mu, r=rb, a=at2}
        val dv2  = vt2a - vt1b
        (* Final burn at r2 *)
        val vt2b = visViva {mu=mu, r=r2, a=at2}
        val v2   = circularV {mu=mu, r=r2}
        val dv3  = v2 - vt2b
        val dvT  = Real.abs dv1 + Real.abs dv2 + Real.abs dv3
    in {dv1=dv1, dv2=dv2, dv3=dv3, dvTotal=dvT} end

  fun tsiolkovsky {isp, m0, mf} = g0 * isp * Math.ln (m0 / mf)

  fun tsiolkovskyVe {ve, m0, mf} = ve * Math.ln (m0 / mf)

  fun soiRadius {a, mSmall, mBig} =
    a * Math.pow (mSmall / mBig, 2.0 / 5.0)
end
