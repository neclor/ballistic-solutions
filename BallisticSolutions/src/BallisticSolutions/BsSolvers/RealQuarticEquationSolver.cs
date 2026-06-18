using MathNet.Numerics;

namespace BallisticSolutions.BsSolvers;

internal static class RealQuarticEquationSolver {
	private const double Epsilon = 1e-3;

	public static double[] Solve(double a = 0, double b = 0, double c = 0, double d = 0, double e = 0)
		=> [
			.. FindRoots.Polynomial([e, d, c, b, a])
				.Where(i => double.Abs(i.Imaginary) < Epsilon)
				.Select(static i => i.Real)
				.Distinct()
				.Order()
		];
}
