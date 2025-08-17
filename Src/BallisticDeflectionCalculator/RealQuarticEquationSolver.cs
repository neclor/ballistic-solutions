using System.Numerics;
using MathNet.Numerics;


namespace BallisticDeflectionCalculator;


internal class RealQuarticEquationSolver {

	public static double[] Solve(double a, double b, double c, double d, double e) {
		return FindRoots.Polynomial([a, b, c, d, e])
			.Where((Complex complexRoot) => complexRoot.Imaginary == 0)
			.Select((Complex complexRoot) => complexRoot.Real)
			.OrderBy((double realRoot) => realRoot)
			.ToArray();
	}
}
