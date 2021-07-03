package wangdaye.com.geometricweather_flutter.basic;

import android.content.Context;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.fragment.app.DialogFragment;
import androidx.lifecycle.LifecycleEventObserver;

import wangdaye.com.geometricweather_flutter.R;

public abstract class GeoDialog extends DialogFragment {

    public static void injectStyle(DialogFragment f) {
        f.getLifecycle().addObserver((LifecycleEventObserver) (source, event) -> {
            switch (event) {
                case ON_CREATE:
                    f.setStyle(STYLE_NO_TITLE, android.R.style.Theme_DeviceDefault_Dialog_MinWidth);
                    break;

                case ON_START:
                    f.requireDialog().getWindow().setBackgroundDrawableResource(R.drawable.dialog_background);
                    break;
            }
        });
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        injectStyle(this);
    }
}
