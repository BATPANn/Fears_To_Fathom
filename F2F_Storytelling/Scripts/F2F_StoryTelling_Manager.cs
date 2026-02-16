using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class F2F_StoryTelling_Manager : MonoBehaviour
{

    public GameObject[] Txts;


    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {

        StartCoroutine(TellStory_Co());

    }


    IEnumerator TellStory_Co()
    {


        yield return new WaitForSeconds(1f);

        Txts[0].SetActive(true);

        yield return new WaitForSeconds(0.05f);
        yield return PressAnyKey_CO();

        Txts[1].SetActive(true);

        yield return new WaitForSeconds(0.05f);
        yield return PressAnyKey_CO();

        Txts[2].SetActive(true);

        yield return new WaitForSeconds(0.05f);
        yield return PressAnyKey_CO();

        Txts[3].SetActive(true);

        yield return new WaitForSeconds(0.05f);
        yield return PressAnyKey_CO();

        Txts[0].SetActive(false);
        Txts[1].SetActive(false);
        Txts[2].SetActive(false);
        Txts[3].SetActive(false);
        Txts[4].SetActive(true);

        yield return new WaitForSeconds(0.05f);
        yield return PressAnyKey_CO();

        Txts[5].SetActive(true);

        yield return new WaitForSeconds(0.05f);
        yield return PressAnyKey_CO();

        // load the next scene
        



    }


    IEnumerator PressAnyKey_CO()
    {

        while (!Input.anyKeyDown)
        {

            yield return null;

        }

    }




    // Update is called once per frame
    void Update()
    {
        
    }
}
