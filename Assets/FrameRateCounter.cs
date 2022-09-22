using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class FrameRateCounter : MonoBehaviour
{
    [SerializeField] private Text frameText; 
    [SerializeField] private Text debugText;

    private void OnEnable()
    {
        Application.targetFrameRate = Screen.currentResolution.refreshRate;
        Application.logMessageReceived += Application_logMessageReceived;
        StartCoroutine(UpdateFrameRate());
    }

    private void OnDisable()
    {
        StopAllCoroutines();
    }

    private WaitForSeconds _frameRateTimerUpdate = new WaitForSeconds(0.5f);
    private IEnumerator UpdateFrameRate()
    {                  
        while (true)
        {
            frameText.text = (Mathf.FloorToInt(1.0f / Time.smoothDeltaTime)).ToString();
            yield return _frameRateTimerUpdate;
        }  
    }

    private void Application_logMessageReceived(string condition, string stackTrace, LogType type)
    {
        debugText.text += string.Format("{0}{1}{2}\n",
            type,
            condition,
            stackTrace);
    }
}
