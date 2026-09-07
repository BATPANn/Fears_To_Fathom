using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

[System.Serializable]
public class VHSPostProcessFeature : CustomPass
{
    private static readonly int CustomTimeId = Shader.PropertyToID("_CustomTime");

    [SerializeField] private Material material;

    protected override void Execute(CustomPassContext ctx)
    {
        if (material == null) return;

        ctx.propertyBlock.SetFloat(CustomTimeId, Time.time);
        CoreUtils.SetRenderTarget(ctx.cmd, ctx.cameraColorBuffer, ClearFlag.None);
        CoreUtils.DrawFullScreen(ctx.cmd, material, ctx.propertyBlock, 0);
    }
}
