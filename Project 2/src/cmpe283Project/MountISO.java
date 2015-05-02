package cmpe283Project;

/**
 * Created by Varun on 4/11/2015.
 */
import com.vmware.vim25.*;
import com.vmware.vim25.mo.EnvironmentBrowser;
import com.vmware.vim25.mo.Task;
import com.vmware.vim25.mo.VirtualMachine;

import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.List;


public class MountISO {

    VirtualMachine vm;

	 /*############################################################
	  CD/DVC Drive Management
	  ############################################################*/

    public void setVirtualMachine(VirtualMachine vm) {
        this.vm = vm;
    }

    public void addCdDriveFromIso(String isoPath, boolean startConnected) throws RemoteException, InterruptedException {
        addCdDrive(isoPath, null, startConnected);
    }

    public void addCdDriveFromHost(String hostDevice, boolean startConnected) throws RemoteException, InterruptedException {
        addCdDrive(null, hostDevice, startConnected);
    }

    private void addCdDrive(String isoPath, String hostDevice, boolean startConnected) throws RemoteException, InterruptedException {
        VirtualMachinePowerState powerState = vm.getRuntime().getPowerState();
        if(powerState != VirtualMachinePowerState.poweredOff) {
            throw new RuntimeException("VM is not yet powered off for adding a CD drive.");
        }

        VirtualCdrom cdrom = new VirtualCdrom();
        cdrom.connectable = new VirtualDeviceConnectInfo();
        cdrom.connectable.allowGuestControl = true;
        cdrom.connectable.startConnected = startConnected;

        if (hostDevice != null) {
            validateCdromHostDevice(hostDevice);
            VirtualCdromAtapiBackingInfo backing = new VirtualCdromAtapiBackingInfo();
            backing.deviceName = hostDevice;
            cdrom.backing = backing;
        }
        else if (isoPath != null) {
            VirtualCdromIsoBackingInfo backing = new VirtualCdromIsoBackingInfo();
            backing.fileName = isoPath;
            cdrom.backing = backing;
        }
        else {
            // We don't allow adding a CD drive without hooking it up to something.
            // In an ideal world, you may want an ISO backing without having to specify a valid ISO
            // at this time. Create a remote passthrough backing and just set it as not connected.
            VirtualCdromRemotePassthroughBackingInfo backing = new VirtualCdromRemotePassthroughBackingInfo();
            backing.exclusive = true;
            backing.deviceName = "";
            cdrom.backing = backing;
        }

        cdrom.key = -1;

        VirtualDeviceConfigSpec cdSpec = new VirtualDeviceConfigSpec();
        cdSpec.operation = VirtualDeviceConfigSpecOperation.add;
        cdSpec.device = cdrom;

        VirtualMachineConfigSpec config = new VirtualMachineConfigSpec();
        config.deviceChange = new VirtualDeviceConfigSpec[] { cdSpec };

        VirtualIDEController controller = getFirstAvailableController(VirtualIDEController.class);

        if (controller != null) {
            config.deviceChange[0].device.controllerKey = controller.key;
        }
        else {
            throw new RuntimeException("No free IDE controller for addtional CD Drive.");
        }

        Task task = vm.reconfigVM_Task(config);
        task.waitForTask();
    }

    private void validateCdromHostDevice(String hostDevice) throws RemoteException {
        List<String> validCdList = getValidCdromOnHost();

        if (!validCdList.contains(hostDevice)) {
            throw new RuntimeException("Invalid host device path for CD drives.");
        }
    }

    private List<String> getValidCdromOnHost() throws RemoteException {
        List<String> result = new ArrayList<String>();

        EnvironmentBrowser envBrower = vm.getEnvironmentBrowser();

        ConfigTarget configTarget;

        try {
            configTarget = envBrower.queryConfigTarget(null);
        }
        catch (Exception ex) {
            throw new RuntimeException("Error in getting Cdrom devices from host.");
        }

        if(configTarget != null && configTarget.cdRom != null) {
            for(VirtualMachineCdromInfo cdromInfo : configTarget.cdRom) {
                result.add(cdromInfo.name);
            }
        }
        return result;
    }

    private <T extends VirtualController> T getFirstAvailableController(Class<T> clazz) {
        VirtualController vc = createControllerInstance(clazz);
        int maxNodes = getMaxNodesPerControllerOfType(vc);

        for (T controller : getVirtualDevicesOfType(clazz)) {
            // Check if controller can accept addition of new devices.
            if (controller.device == null || controller.device.length < maxNodes) {
                return controller;
            }
        }
        return null;
    }

    private <T extends VirtualController> VirtualController createControllerInstance(Class<T> clazz) {
        VirtualController vc = null;
        try {
            vc = (T) clazz.newInstance();
        }
        catch (InstantiationException e) {
            e.printStackTrace();
        }
        catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return vc;
    }

    private static int getMaxNodesPerControllerOfType(VirtualController controller) {
        int count = 0;

        if ( VirtualSCSIController.class.isInstance(controller) ) {
            // The actual device nodes of SCSI controller are 16
            // but one of them is reserved for the controller itself
            // so this means that the maximum free nodes are 15.
            count = 16;
        }
        else if (VirtualIDEController.class.isInstance(controller)) {
            count = 2;
        }
        else {
            throw new RuntimeException("Unknown controller type - " + controller.getDeviceInfo().getLabel());
        }
        return count;
    }

    public <T extends VirtualDevice> List<T> getVirtualDevicesOfType(Class<T> clazz) {
        List<T> result = new ArrayList<T>();

        VirtualDevice[] devices = getAllVirtualDevices();

        for(VirtualDevice dev : devices) {
            if(clazz.isInstance(dev)) {
                result.add((T)dev);
            }
        }
        return result;
    }

    public VirtualDevice[] getAllVirtualDevices() {
        VirtualDevice[] devices = (VirtualDevice[]) vm.getPropertyByPath("config.hardware.device");
        return devices;
    }

}
