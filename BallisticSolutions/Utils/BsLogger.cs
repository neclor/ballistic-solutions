using System.Diagnostics;
using Godot;

namespace BallisticSolutions;

internal class BsLogger {

	private const string LibraryName = "BallisticSolutions";

	public static void FormatWarning(string class_name, string method, string message = "", string returned = "") => Warning(FormatMessage(class_name, method, message, returned));

	public static void FormatError(string class_name, string method, string message = "", string returned = "") => Error(FormatMessage(class_name, method, message, returned));

	public static string FormatMessage(string class_name, string method, string message = "", string returned = "") =>
		$"[{LibraryName}] - `{class_name}.{method}`" + (string.IsNullOrEmpty(message) ? "" : $": {message}.") + (string.IsNullOrEmpty(returned) ? "" : $" Returned {returned}.");

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
}


