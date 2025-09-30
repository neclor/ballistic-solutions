using System.Diagnostics;
#if GODOT
using Godot;
#endif

namespace BallisticSolutions;

/// <summary>
/// Bsc - Ballistic Solutions Calculator. Provides methods for calculating projectile interception with moving targets.
/// It computes interception times, impact positions, and required firing velocities while accounting for both projectile and target velocities and accelerations.
/// </summary>
public static partial class Bsc {

	private const string MessagePrefix = "[BallisticSolutions] - ";

	private static void Warning(string message) {
		Trace.TraceWarning(MessagePrefix + message);
#if GODOT
		GD.PushWarning(MessagePrefix + message);
#endif
	}

	private static void Error(string message) {
		Trace.TraceError(MessagePrefix + message);
#if GODOT
		GD.PushError(MessagePrefix + message);
#endif
	}
}
