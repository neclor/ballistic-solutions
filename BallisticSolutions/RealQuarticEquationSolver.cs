using System.Numerics;
using MathNet.Numerics;


namespace BallisticSolutions;


internal class RealQuarticEquationSolver {

	public static T[] Solve<T>(T a, T b, T c, T d, T e) where T : IFloatingPointIeee754<T> {
		return FindRoots.Polynomial(
			(new T[] { e, d, c, b, a })
				.Select((T coefficient) => double.CreateSaturating(coefficient))
				.ToArray()
		)
			.Where((Complex complexRoot) => complexRoot.Imaginary == 0)
			.Select((Complex complexRoot) => T.CreateSaturating(complexRoot.Real))
			.OrderBy((T realRoot) => realRoot)
			.ToArray();
	}
}
