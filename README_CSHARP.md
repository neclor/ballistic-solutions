# Ballistic Solutions (C#)

---

## Table of Contents

1. [Installation & Dependencies](#installation--dependencies)
2. [Example](#example)
3. [Reference](#reference)

---

## Installation & Dependencies

Two packages are available depending on your project type:

| Package | Vector types |
|---|---|
| [BallisticSolutions](https://www.nuget.org/packages/BallisticSolutions) | `System.Numerics.Vector*` |
| [BallisticSolutions.Godot](https://www.nuget.org/packages/BallisticSolutions.Godot) | `Godot.Vector*` |

### Installation

#### Option 1: NuGet Package (Recommended)

Search for package in the NuGet manager.

Or add to your `.csproj`:

```xml
<!-- Pure .NET -->
<ItemGroup>
  <PackageReference Include="BallisticSolutions" Version="*" />
</ItemGroup>

<!-- Godot -->
<ItemGroup>
  <PackageReference Include="BallisticSolutions.Godot" Version="*" />
</ItemGroup>
```

#### Option 2: DLL (Godot addon)

Add to your `.csproj`:

```xml
<ItemGroup>
  <Reference Include="BallisticSolutions.Godot">
    <HintPath>addons\BallisticSolutions.Godot\BallisticSolutions.Godot.dll</HintPath>
  </Reference>
  <Reference Include="MathNet.Numerics">
    <HintPath>addons\BallisticSolutions.Godot\MathNet.Numerics.dll</HintPath>
  </Reference>
</ItemGroup>
```

### Dependencies

- [MathNet.Numerics](https://www.nuget.org/packages/MathNet.Numerics/)

**BallisticSolutions.Godot:**
- [GodotSharp](https://www.nuget.org/packages/GodotSharp)

---

## Example

```csharp
using Godot;
using BallisticSolutions.BsSolvers.BsVelocity;

// ...

	[Export]
	public PackedScene ProjectileScene { get; set; }

	[Export]
	public float ProjectileSpeed { get; set; } = 200;

	[Export]
	public Vector2 ProjectileAcceleration { get; set; }

	public void Shoot(Target2D target) {
		Vector2 toTarget = target.GlobalPosition - GlobalPosition;

		Vector2 velocity = BsVelocity2D.Best(
			ProjectileSpeed,
			toTarget,
			target.Velocity,
			ProjectileAcceleration,
			target.Acceleration
		);

		if (float.IsNaN(velocity.X)) {
			GD.Print("Impossible to hit the target");
			return;
		}

		var newProjectile = ProjectileScene.Instantiate<Projectile2D>();
		newProjectile.GlobalPosition = GlobalPosition;
		newProjectile.Velocity = velocity;
		newProjectile.Acceleration = ProjectileAcceleration;

		GetParent().AddChild(newProjectile);
	}
```

---

## Reference

For the complete documentation, refer to the generated XML documentation.

`*D` suffix denotes 2D, 3D, or 4D variants — `BsTime*D` stands for `BsTime2D`, `BsTime3D`, and `BsTime4D`. Each variant uses the corresponding `Vector*` type (`Vector2`, `Vector3`, `Vector4`). All variants share the same API.

1. [`BsSolution<T>`](#bssolutiont)
2. [`BsSolution*D`](#bssolutiond)
3. [`BsPosition*D`](#bspositiond)
4. [`BsTime*D`](#bstimed)
5. [`BsVelocity*D`](#bsvelocityd)

---

## `BsSolution<T>`

Abstract base class representing a ballistic solution. `T` is a floating-point numeric type (e.g., `float`, `double`).

| Property | Type | Description |
|---|---|---|
| `Time` | `T` | Interception time. |
| `Position` | `Vector*` | Impact position relative to the projectile origin. |
| `DistanceToPosition` | `float` | Distance to the impact position. |
| `DirectionToPosition` | `Vector*` | Direction to the impact position. |
| `ProjectileVelocity` | `Vector*` | Required firing velocity. |
| `ProjectileSpeed` | `float` | Projectile speed. |
| `ProjectileDirection` | `Vector*` | Projectile direction. |
| `ToTarget` | `Vector*` | Vector from shooter to target at t = 0. |
| `DistanceToTarget` | `float` | Distance to target at t = 0. |
| `DirectionToTarget` | `Vector*` | Direction to target at t = 0. |
| `TargetVelocity` | `Vector*` | Target velocity at t = 0. |
| `TargetSpeed` | `float` | Target speed. |
| `TargetDirection` | `Vector*` | Target direction. |
| `ProjectileAcceleration` | `Vector*` | Projectile acceleration. |
| `TargetAcceleration` | `Vector*` | Target acceleration. |

---

## `BsSolution*D`

```csharp
BsSolution*D<T>? Best<T>(float projectileSpeed, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** the earliest valid solution, or `null` if interception is impossible.

---

```csharp
BsSolution*D<T>? Best<T>(Vector* projectileDirection, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** the earliest valid solution, or `null` if interception is impossible.

---

```csharp
BsSolution*D<T>[] All<T>(float projectileSpeed, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** all valid solutions sorted by interception time. Empty array if impossible.

---

```csharp
BsSolution*D<T>[] All<T>(Vector* projectileDirection, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** all valid solutions sorted by interception time. Empty array if impossible.

---

## `BsPosition*D`

```csharp
Vector* Displacement<T>(T time, Vector* velocity, Vector* acceleration = default)
```
**Returns:** displacement under constant acceleration.

---

```csharp
Vector* Position<T>(Vector* position, T time, Vector* velocity, Vector* acceleration = default)
```
**Returns:** position after elapsed time under constant acceleration.

---

```csharp
Vector* Best(float projectileSpeed, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** the earliest valid impact position. Returns a `NaN` vector if impossible.

---

```csharp
Vector* Best(Vector* projectileDirection, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** the earliest valid impact position. Returns a `NaN` vector if impossible.

---

```csharp
Vector*[] All(float projectileSpeed, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** all valid impact positions. Empty array if impossible.

---

```csharp
Vector*[] All(Vector* projectileDirection, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** all valid impact positions. Empty array if impossible.

---

## `BsTime*D`

```csharp
T Best<T>(float projectileSpeed, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** the earliest interception time (t ≥ 0). Returns `NaN` if impossible.

---

```csharp
T Best<T>(Vector* projectileDirection, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** the earliest interception time (t ≥ 0). Returns `NaN` if impossible.

---

```csharp
T[] All<T>(float projectileSpeed, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** all valid interception times sorted ascending. Empty array if impossible.

---

```csharp
T[] All<T>(Vector* projectileDirection, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** all valid interception times sorted ascending. Empty array if impossible.

---

## `BsVelocity*D`

```csharp
Vector* Velocity<T>(T time, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** the firing velocity required to hit the target at the given time.

---

```csharp
Vector* Best(float projectileSpeed, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** the earliest valid firing velocity. Returns a `NaN` vector if impossible.

---

```csharp
Vector* Best(Vector* projectileDirection, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** the earliest valid firing velocity. Returns a `NaN` vector if impossible.

---

```csharp
Vector*[] All(float projectileSpeed, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** all valid firing velocities. Empty array if impossible.

---

```csharp
Vector*[] All(Vector* projectileDirection, Vector* toTarget, Vector* targetVelocity = default, Vector* projectileAcceleration = default, Vector* targetAcceleration = default)
```
**Returns:** all valid firing velocities. Empty array if impossible.
