# Ballistic Solutions (С#)

---

## Table of Contents

1. [Installation & Dependencies](#installation--dependencies)
2. [Example](#example)
3. [Reference](#reference)

---

## Installation & Dependencies

### Installation

#### Option 1: Using IDE

To use this library, you need to reference the compiled `.dll` file in your project.

1. Right-click on your project in **Solution Explorer** -> **Add** -> **Project Reference…**.
2. Select **Browse…** and choose the `BallisticSolutions.dll` file.
3. Install [MathNet.Numerics](https://www.nuget.org/packages/MathNet.Numerics/) **Or** choose the `MathNet.Numerics.dll` file similarly to step 2.
4. Confirm and rebuild your project.

#### Option 2: Edit the .csproj file directly

1. Add a `<Reference>` entry for the `BallisticSolutions.dll` in `<ItemGroup>`
	```xml
	<ItemGroup>
	  <Reference Include="BallisticSolutions">
		<HintPath>addons\BallisticSolutionsCSharp\BallisticSolutions.dll</HintPath>
	  </Reference>
	</ItemGroup>
	```

2. Add NuGet dependencies: [MathNet.Numerics](https://www.nuget.org/packages/MathNet.Numerics/)
	```xml
	<ItemGroup>
	  <PackageReference Include="MathNet.Numerics" Version="5.0.0" />
	</ItemGroup>
	```

	**Or** Add a `<Reference>` entry for the `MathNet.Numerics.dll` in `<ItemGroup>`
	```xml
	<ItemGroup>
	  <Reference Include="MathNet.Numerics">
		<HintPath>addons\BallisticSolutionsCSharp\MathNet.Numerics.dll</HintPath>
	  </Reference>
	</ItemGroup>
	```

---

### Dependencies
- [MathNet.Numerics](https://www.nuget.org/packages/MathNet.Numerics/) (recommended via NuGet).

---

## Example
---

```csharp
using Godot;
using BallisticSolutions;

// ...

	[Export]
	public PackedScene ProjectilePackedScene { get; set; }

	[Export]
	public float ProjectileSpeed { get; set; } = 200f;
	[Export]
	public Vector2 ProjectileAcceleration { get; set; } = Vector2.Zero;

	public void Shoot(Target2D target) {
		Vector2 toTarget = target.GlobalPosition - GlobalPosition;
		Vector2 velocity = BsVelocity.BestFiringVelocity(ProjectileSpeed, toTarget, target.Velocity, ProjectileAcceleration, target.Acceleration);

		if (float.IsNaN(velocity.X)) {
			GD.Print("Impossible to hit the target");
			return;
		}

		var newProjectile = ProjectilePackedScene.Instantiate<Projectile2D>();
		newProjectile.GlobalPosition = GlobalPosition;
		newProjectile.Velocity = velocity;
		newProjectile.Acceleration = ProjectileAcceleration;
	
		GetParent().AddChild(newProjectile);
	}
```

---

## Reference

For the complete documentation, rely on the generated XML documentation.  
Not all namespaces, classes, and methods are listed.  

1. `BallisticSolutions`
	1. [`BsPosition`](#bsposition)
	2. [`BsTime`](#bstime)
	3. [`BsVelocity`](#bsvelocity)

---

## `BsPosition`

```csharp
Vector4[] AllImpactPositions(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** all possible impact positions corresponding to valid interception times.

---

```csharp
Vector4[] AllImpactPositions<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** all possible impact positions using a scalar projectile speed.

---

```csharp
Vector4 BestImpactPosition(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** the impact position of the earliest valid interception or NaN vector if impossible.

---

```csharp
Vector4 BestImpactPosition<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** the earliest impact position using a scalar projectile speed.

---

```csharp
Vector4 Displacement<T>(T time, Vector4 velocity, Vector4 acceleration = default)
```
**Returns:** displacement under constant acceleration.

---

```csharp
Vector4 Position<T>(Vector4 position, T time, Vector4 velocity = default, Vector4 acceleration = default)
```
**Returns:** position after elapsed time under constant acceleration.

---

## `BsTime`

```csharp
T[] AllImpactTimes<T>(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** all valid interception times (t > 0), sorted ascending.

---

```csharp
T[] AllImpactTimes<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** all valid interception times using a scalar projectile speed.

---

```csharp
T BestImpactTime<T>(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** the earliest valid interception time or NaN if none exists.

---

```csharp
T BestImpactTime<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** the earliest valid interception time using a scalar projectile speed.

---

## `BsVelocity`

```csharp
Vector4[] AllFiringVelocities(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** all firing velocities corresponding to valid interception times.

---

```csharp
Vector4[] AllFiringVelocities<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** all firing velocities using a scalar projectile speed.

---

```csharp
Vector4 BestFiringVelocity(Vector4 projectileDirection, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** the firing velocity for the earliest valid interception or NaN vector if impossible.

---

```csharp
Vector4 BestFiringVelocity<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** the firing velocity using a scalar projectile speed.

---

```csharp
Vector4 FiringVelocity<T>(T impactTime, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default)
```
**Returns:** the firing velocity required to hit the target at a specific interception time.
