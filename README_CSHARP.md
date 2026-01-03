# Ballistic Solutions (С#)

---

## Table of Contents

1. [Installation & Dependencies](#installation)
2. [Example](#example)
3. [Reference](#reference)

---

## <a name="installation"></a>Installation & Dependencies

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

## <a name="example"></a>Example
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
        Vector2 velocity = Bsc.BestFiringVelocity(ProjectileSpeed, toTarget, target.Velocity, ProjectileAcceleration, target.Acceleration);

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

    public float GetBestImpactTime(Target2D target) {
        Vector2 toTarget = target.GlobalPosition - GlobalPosition;
        float bestImpactTime = Bsc.BestImpactTime(ProjectileSpeed, toTarget, target.Velocity, ProjectileAcceleration, target.Acceleration);
        return bestImpactTime;
    }

    public Vector2 GetBestImpactPosition(Target2D target) {
        Vector2 toTarget = target.GlobalPosition - GlobalPosition;
        Vector2 bestImpactPosition = GlobalPosition + Bsc.BestImpactPosition(ProjectileSpeed, toTarget, target.Velocity, ProjectileAcceleration, target.Acceleration);
        return bestImpactPosition;
    }
```

---

## <a name="reference"></a>Reference

1. [BallisticSolutions](#ballistic-solutions)
    1. [Bsc](#bsc)
        1. [Time](#time)
        2. [Position](#position)
        3. [Velocity](#velocity)

## <a name="ballistic-solutions"></a>Namespace: `BallisticSolutions`

### <a name="bsc"></a>Class: `Bsc`

#### <a name="time"></a>Methods: Time

Computes the earliest positive interception time between a projectile and a moving target.  
Overloads for `Vector2`, `Vector3`, `Vector4`.
```csharp
T BestImpactTime<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>;
```

Computes all possible interception times between a projectile and a moving target.  
Overloads for `Vector2`, `Vector3`, `Vector4`.
```csharp
T[] ImpactTimes<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>;
```

#### <a name="position"></a>Methods: Position

Computes displacement under constant acceleration.  
Overloads for `Vector2`, `Vector3`, `Vector4`.
```csharp
Vector4 Displacement<T>(T time, Vector4 velocity, Vector4 acceleration = default) where T : IFloatingPointIeee754<T>;
```

Computes the impact position of the earliest valid interception.  
Overloads for `Vector2`, `Vector3`, `Vector4`.
```csharp
Vector4 BestImpactPosition<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>;
```

Computes all possible impact positions corresponding to valid interception times.  
Overloads for `Vector2`, `Vector3`, `Vector4`.
```csharp
Vector4[] ImpactPositions<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>;

```

#### <a name="velocity"></a>Methods: Velocity

Computes the firing velocity required to hit the target at a given interception time.  
Overloads for `Vector2`, `Vector3`, `Vector4`.
```csharp
Vector4 FiringVelocity<T>(T impactTime, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>;
```

Computes the firing velocity required for the earliest valid interception.  
Overloads for `Vector2`, `Vector3`, `Vector4`.
```csharp
Vector4 BestFiringVelocity<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>;
```

Computes firing velocities for all valid interception times.  
Overloads for `Vector2`, `Vector3`, `Vector4`.
```csharp
Vector4[] FiringVelocities<T>(T projectileSpeed, Vector4 toTarget, Vector4 targetVelocity = default, Vector4 projectileAcceleration = default, Vector4 targetAcceleration = default) where T : IFloatingPointIeee754<T>;
```

---
