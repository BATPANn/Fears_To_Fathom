using UnityEngine;
using TMPro;
using System.Collections;
using System.Text;

public class F2F_DialogueBackground_Method02 : MonoBehaviour
{


    public TextMeshProUGUI Backtext;
    public TextMeshProUGUI ForwardText;

    string holder = "";

    public float typetime = 0.25f;



    private void Start()
    {

        StartCoroutine(TypeDialogue_CO());
    }

    private IEnumerator TypeDialogue_CO()
    {


        Backtext.text = "";
        ForwardText.text = "";

        holder = "HELLO, I'M BATPAN. THIS VIDEO IS FUN.";

        StringBuilder sb = new StringBuilder(holder.Length);

        foreach(char c in holder)
        {

            sb.Append(c);

            string currentstring = sb.ToString();

            ForwardText.text = currentstring;

            Backtext.text = $"<mark=#000000>{currentstring}</mark>";

            yield return new WaitForSeconds(typetime);

        }


    }


}
