using System.Numerics;
using MathNet.Numerics;

namespace BallisticSolutions;

internal class RealQuarticEquationSolver {

	public static T[] Solve<T>(T a, T b, T c, T d, T e) where T : IFloatingPointIeee754<T> =>
		[..
			FindRoots.Polynomial(
				[..
					(new T[] { e, d, c, b, a })
						.Select(coefficient => double.CreateSaturating(coefficient))
				]
			)
				.Where(complexRoot => complexRoot.Imaginary == 0)
				.Select(complexRoot => T.CreateSaturating(complexRoot.Real))
				.Order()
		];
}
