# BDC - Ballistic Deflection Calculator
Ballistic deflection calculator is a tool for calculating the shot vector considering speeds and accelerations for Godot.


## Methods

### GDScipt
```gdscript
Bdc


# Times To Hit

Array[float] times_to_hit(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static

Array[float] times_to_hit_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) static

Array[float] times_to_hit_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) static

Array[float] times_to_hit_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) static


# Velocities

Array velocities(projectile_speed: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static

Array[Vector2] velocities_vector2(projectile_speed: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) static

Array[Vector3] velocities_vector3(projectile_speed: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) static

Array[Vector4] velocities_vector4(projectile_speed: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) static


# Velocity From Time To Hit

Variant velocity_from_time_to_hit(time_to_hit: float, to_target: Variant, target_velocity: Variant = Vector4.ZERO, projectile_acceleration: Variant = Vector4.ZERO, target_acceleration: Variant = Vector4.ZERO) static

Vector2 velocity_from_time_to_hit_vector2(time_to_hit: float, to_target: Vector2, target_velocity: Vector2 = Vector2.ZERO, projectile_acceleration: Vector2 = Vector2.ZERO, target_acceleration: Vector2 = Vector2.ZERO) static

Vector3 velocity_from_time_to_hit_vector3(time_to_hit: float, to_target: Vector3, target_velocity: Vector3 = Vector3.ZERO, projectile_acceleration: Vector3 = Vector3.ZERO, target_acceleration: Vector3 = Vector3.ZERO) static

Vector4 velocity_from_time_to_hit_vector4(time_to_hit: float, to_target: Vector4, target_velocity: Vector4 = Vector4.ZERO, projectile_acceleration: Vector4 = Vector4.ZERO, target_acceleration: Vector4 = Vector4.ZERO) static
```

### C#
```csharp 
BallisticDeflectionCalculator.Bdc;


// Times To Hit

T[] TimesToHit<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPoint<T>;

T[] TimesToHit<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPoint<T>;

T[] TimesToHit<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPoint<T>;


// Velocities

Vector2[] Velocities<T>(T projectileSpeed, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPoint<T>;

Vector3[] Velocities<T>(T projectileSpeed, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPoint<T>;

Vector4[] Velocities<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPoint<T>;


// Velocity From Time To Hit

Vector2 VelocityFromTimeToHit<T>(T timeToHit, Vector2 toTarget, Vector2 targetVelocity = default, Vector2 projectileAcceleration = default, Vector2 targetAcceleration = default) where T : IFloatingPoint<T>;

Vector3 VelocityFromTimeToHit<T>(T timeToHit, Vector3 toTarget, Vector3 targetVelocity = default, Vector3 projectileAcceleration = default, Vector3 targetAcceleration = default) where T : IFloatingPoint<T>;

Vector4 VelocityFromTimeToHit<T>(T timeToHit, Vector4 toTarget, Vector2 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPoint<T>;
```


## Example
### GDScipt
```gdscript
@export var projectile_packed_scene: PackedScene

var projectile_speed: float = 200
var projectile_acceleration: Vector2 = Vector2.ZERO

func shoot(target: Target2D) -> void:
	var to_target: Vector2 = target.global_position - global_position

	var projectile_velocities: Array[Vector2] = Bdc.velocities_vector2(bullet_speed, to_target, target.velocity, projectile_acceleration, target.acceleration)

	if projectile_velocities.size() == 0:
		print("Impossible to hit the target")
		return

	var new_projectile: Projectile2D = projectile_packed_scene.instantiate()
	new_projectile.global_position = global_position
	new_projectile.velocity = bullet_velocities[0]
	new_projectile.acceleration = projectile_acceleration

	get_parent().add_child(new_projectile)
```

### C#
```csharp
using Godot;
using BallisticDeflectionCalculator;

// ...

[Export]
public PackedScene? ProjectilePackedScene { get; set; }

public float ProjectileSpeed { get; set; } = 200;
public Vector2 ProjectileAcceleration { get; set; } = Vector2.Zero;

public void Shoot(Target2D target) {
	Vector2 toTarget = target.GlobalPosition - GlobalPosition;

	Vector2[] projectileVelocities = Bdc.Velocities(ProjectileSpeed, toTarget, target.Velocity, ProjectileAcceleration, target.Acceleration);

	if (projectileVelocities.Length == 0) {
		GD.Print("Impossible to hit the target");
		return;
	}

	Projectile2D newProjectile = ProjectilePackedScene.Instantiate<Projectile2D>();
	newProjectile.GlobalPosition = GlobalPosition;
	newProjectile.Velocity = projectileVelocities[0];
	newProjectile.Acceleration = ProjectileAcceleration;

	GetParent().AddChild(newProjectile);
}
```

## Adding the `Ballistic Deflection Calculator` to your C# project

### Option 1: Using IDE
To use this library, you need to reference the compiled `.dll` file in your project.
1. Right-click on your project in **Solution Explorer** -> **Add** -> **Project Reference…**.
2. Select **Browse…** and choose the `BallisticDeflectionCalculator.dll` file.
3. Install [MathNet.Numerics](https://www.nuget.org/packages/MathNet.Numerics/) **Or** choose the `MathNet.Numerics.dll` file similarly to step 2.
4. Confirm and rebuild your project.
5. Add the namespace in your code:
```csharp
using BallisticDeflectionCalculator;
```

### Option 2: Edit the .csproj file directly
1. Add a `<Reference>` entry for the `BallisticDeflectionCalculator.dll` in `<ItemGroup>`
```xml
  <ItemGroup>
    <Reference Include="BallisticDeflectionCalculator">
      <HintPath>addons\BallisticDeflectionCalculatorCSharp\BallisticDeflectionCalculator.dll</HintPath>
    </Reference>
  </ItemGroup>
```
2. Add NuGet dependencies: [MathNet.Numerics](https://www.nuget.org/packages/MathNet.Numerics/)
```xml
  <ItemGroup>
    <PackageReference Include="MathNet.Numerics" Version="5.0.0" />
  </ItemGroup>
```
- **Or** Add a `<Reference>` entry for the `MathNet.Numerics.dll` in `<ItemGroup>`
```xml
  <ItemGroup>
    <Reference Include="MathNet.Numerics">
      <HintPath>addons\BallisticDeflectionCalculatorCSharp\MathNet.Numerics.dll</HintPath>
    </Reference>
  </ItemGroup>
```


## Demo
You can test the addon using the included demo scene.

![Demo Screenshot](docs/screenshot.png)


## Dependencies
- **GDScript version:** 
	- [RES – Real Equation Solver (GitHub)](https://github.com/neclor/godot-real-equation-solver)
	- [RES – Real Equation Solver (Asset Library)](https://godotengine.org/asset-library/asset/2998)
- **C# version:**
	- [MathNet.Numerics](https://www.nuget.org/packages/MathNet.Numerics/)


## How it works?
[Formula](docs/Formula.md)
