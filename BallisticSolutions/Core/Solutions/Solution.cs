namespace BallisticSolutions;

/// <summary>
/// Abstract base class for typed ballistic solutions.
/// </summary>
public abstract class Solution {


	public float Time { get; init; } = float.NaN;


	public bool IsValid => !float.IsNaN(Time) && Time > 0;


	protected Solution(float time) => Time = time;
}
