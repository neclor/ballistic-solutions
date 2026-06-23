# Ballistic Solutions (C#)

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

```csharp
using Godot;
using BallisticSolutions.BsSolutions;

// ...

	[Export]
	public PackedScene ProjectilePackedScene { get; set; }

	[Export]
	public float ProjectileSpeed { get; set; } = 200f;
	[Export]
	public Vector2 ProjectileAcceleration { get; set; } = Vector2.Zero;

	public void Shoot(Target2D target) {
		Vector2 toTarget = target.GlobalPosition - GlobalPosition;
		BsSolution2D<float>? solution = BsSolution2D.Best<float>(ProjectileSpeed, toTarget, target.Velocity, ProjectileAcceleration, target.Acceleration);

		if (solution == null) {
			GD.Print("Impossible to hit the target");
			return;
		}

		var newProjectile = ProjectilePackedScene.Instantiate<Projectile2D>();
		newProjectile.GlobalPosition = GlobalPosition;
		newProjectile.Velocity = solution.ProjectileVelocity;
		newProjectile.Acceleration = ProjectileAcceleration;

		GetParent().AddChild(newProjectile);
	}
```

---

## Reference

For the complete documentation, rely on the generated XML documentation.

`Nd` suffix denotes 2D, 3D, or 4D variants — `BsTimeNd` stands for `BsTime2D`, `BsTime3D`, and `BsTime4D`. Each variant uses the corresponding `VectorN` type (`Vector2`, `Vector3`, `Vector4`). All variants share the same API.

1. [`BsSolution<T>`](#bssolutiont)
2. [`BsSolutionNd`](#bssolutionnd)
3. [`BsPositionNd`](#bspositionnd)
4. [`BsTimeNd`](#bstimend)
5. [`BsVelocityNd`](#bsvelocitynd)

---

## `BsSolution<T>`

Abstract base class representing a ballistic solution. `T` is a floating-point numeric type (e.g., `float`, `double`).

| Property | Type | Description |
|---|---|---|
| `Time` | `T` | Interception time. |
| `Position` | `VectorN` | Impact position relative to the projectile origin. |
| `DistanceToPosition` | `float` | Distance to the impact position. |
| `DirectionToPosition` | `VectorN` | Direction to the impact position. |
| `ProjectileVelocity` | `VectorN` | Required firing velocity. |
| `ProjectileSpeed` | `float` | Projectile speed. |
| `ProjectileDirection` | `VectorN` | Projectile direction. |
| `ToTarget` | `VectorN` | Vector from shooter to target at t = 0. |
| `DistanceToTarget` | `float` | Distance to target at t = 0. |
| `DirectionToTarget` | `VectorN` | Direction to target at t = 0. |
| `TargetVelocity` | `VectorN` | Target velocity at t = 0. |
| `TargetSpeed` | `float` | Target speed. |
| `TargetDirection` | `VectorN` | Target direction. |
| `ProjectileAcceleration` | `VectorN` | Projectile acceleration. |
| `TargetAcceleration` | `VectorN` | Target acceleration. |

---

## `BsSolutionNd`

```csharp
BsSolutionNd<T>? Best<T>(float projectileSpeed, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** the earliest valid solution, or `null` if interception is impossible.

---

```csharp
BsSolutionNd<T>? Best<T>(VectorN projectileDirection, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** the earliest valid solution, or `null` if interception is impossible.

---

```csharp
BsSolutionNd<T>[] All<T>(float projectileSpeed, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** all valid solutions sorted by interception time. Empty array if impossible.

---

```csharp
BsSolutionNd<T>[] All<T>(VectorN projectileDirection, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** all valid solutions sorted by interception time. Empty array if impossible.

---

## `BsPositionNd`

```csharp
VectorN Displacement<T>(T time, VectorN velocity, VectorN acceleration = default)
```
**Returns:** displacement under constant acceleration.

---

```csharp
VectorN Position<T>(VectorN position, T time, VectorN velocity, VectorN acceleration = default)
```
**Returns:** position after elapsed time under constant acceleration.

---

```csharp
VectorN Best(float projectileSpeed, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** the earliest valid impact position. Returns a `NaN` vector if impossible.

---

```csharp
VectorN Best(VectorN projectileDirection, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** the earliest valid impact position. Returns a `NaN` vector if impossible.

---

```csharp
VectorN[] All(float projectileSpeed, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** all valid impact positions. Empty array if impossible.

---

```csharp
VectorN[] All(VectorN projectileDirection, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** all valid impact positions. Empty array if impossible.

---

## `BsTimeNd`

```csharp
T Best<T>(float projectileSpeed, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** the earliest interception time (t ≥ 0). Returns `NaN` if impossible.

---

```csharp
T Best<T>(VectorN projectileDirection, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** the earliest interception time (t ≥ 0). Returns `NaN` if impossible.

---

```csharp
T[] All<T>(float projectileSpeed, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** all valid interception times sorted ascending. Empty array if impossible.

---

```csharp
T[] All<T>(VectorN projectileDirection, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** all valid interception times sorted ascending. Empty array if impossible.

---

## `BsVelocityNd`

```csharp
VectorN Velocity<T>(T time, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** the firing velocity required to hit the target at the given time.

---

```csharp
VectorN Best(float projectileSpeed, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** the earliest valid firing velocity. Returns a `NaN` vector if impossible.

---

```csharp
VectorN Best(VectorN projectileDirection, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** the earliest valid firing velocity. Returns a `NaN` vector if impossible.

---

```csharp
VectorN[] All(float projectileSpeed, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** all valid firing velocities. Empty array if impossible.

---

```csharp
VectorN[] All(VectorN projectileDirection, VectorN toTarget, VectorN targetVelocity = default, VectorN projectileAcceleration = default, VectorN targetAcceleration = default)
```
**Returns:** all valid firing velocities. Empty array if impossible.
