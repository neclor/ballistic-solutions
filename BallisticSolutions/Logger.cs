using System.Diagnostics;
using Godot;

namespace BallisticSolutions;

internal class Logger {

	private const string MessagePrefix = "[BallisticSolutions] - ";

	public static void PushWarning(string message) {
		Trace.TraceWarning(MessagePrefix + message);
#if GODOT
		GD.PushWarning(MessagePrefix + message);
#endif
	}

	public static void PushError(string message) {
		Trace.TraceError(MessagePrefix + message);
#if GODOT
		GD.PushError(MessagePrefix + message);
#endif
	}
}
