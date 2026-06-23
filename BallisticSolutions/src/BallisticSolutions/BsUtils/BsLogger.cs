using System.Diagnostics;
using System.Runtime.CompilerServices;

namespace BallisticSolutions.BsUtils;

internal static class BsLogger {
	private const string Library = "[BallisticSolutions]";

	public static void Error(string message, [CallerMemberName] string method = "")
		=> Trace.TraceError($"{Library} {method}: {message}");
}
