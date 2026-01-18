using System.Diagnostics;
using Godot;

namespace BallisticSolutions;

internal class Logger {

	private const string LibraryName = "BallisticSolutions";

	public static void Error(string message) {
		Trace.TraceError(message);
#if GODOT
		GD.PushError(message);
#endif
	}

	public static void Warning(string message) {
		Trace.TraceWarning(message);
#if GODOT
		GD.PushWarning(message);
#endif
	}

	public static void FormatError(string @class, string method, string message = "", string returned = "") => Error(FormatMessage(@class, method, message, returned));

	public static void FormatWarning(string @class, string method, string message = "", string returned = "") => Warning(FormatMessage(@class, method, message, returned));

	public static string FormatMessage(string @class, string method, string message = "", string returned = "") => $"[{LibraryName}] - `{@class}.{method}`" + (string.IsNullOrEmpty(message) ? "" : $": {message}.") + (string.IsNullOrEmpty(returned) ? "" : $" Returned {returned}.");
