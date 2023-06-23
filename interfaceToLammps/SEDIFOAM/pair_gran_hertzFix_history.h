/* ----------------------------------------------------------------------
   LAMMPS - Large-scale Atomic/Molecular Massively Parallel Simulator
   http://lammps.sandia.gov, Sandia National Laboratories
   Steve Plimpton, sjplimp@sandia.gov

   Copyright (2003) Sandia Corporation.  Under the terms of Contract
   DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains
   certain rights in this software.  This software is distributed under
   the GNU General Public License.

   See the README file in the top-level LAMMPS directory.
------------------------------------------------------------------------- */

#ifdef PAIR_CLASS
// clang-format off
PairStyle(gran/hertzFix/history,PairGranHertzFixHistory)
// clang-format on
#else

#ifndef LMP_PAIR_GRAN_HERTZFIX_HISTORY_H
#define LMP_PAIR_GRAN_HERTZFIX_HISTORY_H

#include "pair_gran_hooke_history.h"

namespace LAMMPS_NS {

class PairGranHertzFixHistory : public PairGranHookeHistory {
 public:
  PairGranHertzFixHistory(class LAMMPS *);
  void compute(int, int) override;
  void settings(int, char **) override;
  double single(int, int, int, int, double, double, double, double &) override;
};

}

#endif
#endif

/* ERROR/WARNING messages:

E: Illegal ... command

Self-explanatory.  Check the input script syntax and compare to the
documentation for the command.  You can use -echo screen as a
command-line option when running LAMMPS to see the offending line.

*/
