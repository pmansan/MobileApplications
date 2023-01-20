using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayButton : MonoBehaviour
{
    public float counter=0;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (counter < 3)
        {
            counter += Time.fixedDeltaTime;
        }
        else
        {

        }
        counter += Time.fixedDeltaTime;
        //transform.Translate(0, 0.005f, 0);

        //if (counter > 4) { }
    }
}
