using BallisticSolutions;


#if GODOT
using Vector2 = Godot.Vector2;
using Vector3 = Godot.Vector3;
using Vector4 = Godot.Vector4;
#else
using Vector2 = System.Numerics.Vector2;
using Vector3 = System.Numerics.Vector3;
using Vector4 = System.Numerics.Vector4;
#endif



namespace BallisticSolutions.Test;


internal class Test {

	static void Main() {
		Console.WriteLine("Ballistic Solutions Test");









		Console.WriteLine("Ballistic Solutions Test Completed");
	}



	void BestImpactTime() {









	}






		void TestTime() {

		float projectileSpeed = 50;
		Vector3 toTarget = new Vector3(100, 0, 0);
		Vector3 targetVelocity = new Vector3(10, 0, 0);
		Vector3 projectileAcceleration = new Vector3(0, 0, 0);
		Vector3 targetAcceleration = new Vector3(0, 0, 0);
		float[] impactTimes = Bsc.ImpactTimes(projectileSpeed, toTarget, targetVelocity, projectileAcceleration, targetAcceleration);
		if (impactTimes.Length == 0) {
			Console.WriteLine("No impact possible.");
		} else {
			foreach (float time in impactTimes) {
				Console.WriteLine($"Impact time: {time} seconds");
			}
		}







	}


	void TestPosition() {







	}

	void TestVelocity() {







	}













}
