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

	const string MessagePrefix = "[BallisticSolutions] - ";

	static void Warning(string message) {
		Trace.WriteLine("WARNING: " + MessagePrefix + message);
#if GODOT
		GD.PushWarning(MessagePrefix + message);
#endif
	}

	static void Error(string message) {
		Trace.WriteLine("ERROR: " + MessagePrefix + message);
#if GODOT
		GD.PushError(MessagePrefix + message);
#endif
	}
}
