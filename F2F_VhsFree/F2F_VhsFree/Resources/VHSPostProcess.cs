using UnityEngine;

[ExecuteInEditMode]
public class VHSPostProcess : MonoBehaviour
{
    public Material VHSMaterial;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (VHSMaterial != null)
        {
            Graphics.Blit(src, dest, VHSMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
